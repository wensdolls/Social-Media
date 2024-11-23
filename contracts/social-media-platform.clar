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


