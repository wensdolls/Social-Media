;; utils.clar

(define-trait utils-trait
  (
    (principal-to-string (principal) (response (string-ascii 128) uint))
  )
)

(define-public (principal-to-string (value principal))
  (ok (unwrap-panic (principal-to-string? value)))
)

(define-public (string-to-principal (value (string-ascii 128)))
  (ok (unwrap-panic (principal-of? value)))
)

