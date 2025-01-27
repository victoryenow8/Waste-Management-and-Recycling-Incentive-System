;; Smart Bin Integration Contract

(define-map smart-bins
  { bin-id: uint }
  {
    location: (string-ascii 100),
    capacity: uint,
    current-fill: uint,
    last-updated: uint,
    status: (string-ascii 20)
  }
)

(define-data-var bin-nonce uint u0)

(define-public (register-smart-bin (location (string-ascii 100)) (capacity uint))
  (let
    ((new-id (+ (var-get bin-nonce) u1)))
    (map-set smart-bins
      { bin-id: new-id }
      {
        location: location,
        capacity: capacity,
        current-fill: u0,
        last-updated: block-height,
        status: "active"
      }
    )
    (var-set bin-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-bin-status (bin-id uint) (new-fill uint))
  (let
    ((bin (unwrap! (map-get? smart-bins { bin-id: bin-id }) (err u404))))
    (map-set smart-bins
      { bin-id: bin-id }
      (merge bin {
        current-fill: new-fill,
        last-updated: block-height
      })
    )
    (ok true)
  )
)

(define-read-only (get-bin-status (bin-id uint))
  (map-get? smart-bins { bin-id: bin-id })
)

