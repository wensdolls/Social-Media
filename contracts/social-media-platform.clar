;; social-media-platform.clar

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))
(define-constant err-already-exists (err u103))

;; Data variables
(define-data-var next-post-id uint u0)

;; Data maps
(define-map users
  { username: (string-ascii 20) }
  {
    address: principal,
    display-name: (string-utf8 50),
    bio: (string-utf8 280)
  }
)

(define-map posts
  { post-id: uint }
  {
    author: principal,
    content: (string-utf8 1000),
    likes: uint
  }
)

;; Read-only functions
(define-read-only (get-user (username (string-ascii 20)))
  (map-get? users { username: username })
)

(define-read-only (get-post (post-id uint))
  (map-get? posts { post-id: post-id })
)

;; Public functions
(define-public (create-user (username (string-ascii 20)) (display-name (string-utf8 50)) (bio (string-utf8 280)))
  (let
    (
      (user tx-sender)
    )
    (asserts! (is-none (get-user username)) (err err-already-exists))
    (ok (map-set users
      { username: username }
      {
        address: user,
        display-name: display-name,
        bio: bio
      }
    ))
  )
)

(define-public (create-post (content (string-utf8 1000)))
  (let
    (
      (user tx-sender)
      (post-id (var-get next-post-id))
    )
    (map-set posts
      { post-id: post-id }
      {
        author: user,
        content: content,
        likes: u0
      }
    )
    (var-set next-post-id (+ post-id u1))
    (ok post-id)
  )
)

(define-public (like-post (post-id uint))
  (let
    (
      (post (unwrap! (get-post post-id) (err err-not-found)))
    )
    (ok (map-set posts
      { post-id: post-id }
      (merge post { likes: (+ (get likes post) u1) })
    ))
  )
)

;; Admin functions
(define-public (update-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err err-owner-only))
    (ok true)
  )
)

