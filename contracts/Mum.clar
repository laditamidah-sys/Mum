;; winning-contract.clar
;; Unique, concise Clarity contract for Google Web3

;; Track registered participants
(define-map participants ((addr principal)) ((registered bool)))

;; Track contract winner
(define-data-var winner (optional principal) none)

;; Register a participant
(define-public (register)
  (begin
    (if (map-get participants tx-sender)
        (err u1) ;; Already registered
        (map-set participants tx-sender ((registered true))))
    (ok tx-sender)
  )
)

;; Select a winner deterministically
(define-public (select-winner)
  (begin
    (if (is-some (var-get winner))
        (err u2) ;; Winner already selected
        (let ((all (map-keys participants)))
          (if ((len all) u0)
              (err u3) ;; No participants
              (let ((chosen (element-at all (mod (block-height) (len all)))))
                (var-set winner (some chosen))
                (ok chosen)
              )
          )
        )
    )
  )
)

;; View winner
(define-public (view-winner)
  (ok (var-get winner))
)
