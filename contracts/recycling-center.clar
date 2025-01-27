;; Recycling Center Operations Contract

(define-map recycling-centers
  { center-id: uint }
  {
    operator: principal,
    location: (string-ascii 100),
    capacity: uint,
    status: (string-ascii 20)
  }
)

(define-map recycling-batches
  { batch-id: uint }
  {
    center-id: uint,
    waste-type: (string-ascii 20),
    amount: uint,
    timestamp: uint,
    status: (string-ascii 20)
  }
)

(define-data-var center-nonce uint u0)
(define-data-var batch-nonce uint u0)

(define-public (register-center (location (string-ascii 100)) (capacity uint))
  (let
    ((new-id (+ (var-get center-nonce) u1)))
    (map-set recycling-centers
      { center-id: new-id }
      {
        operator: tx-sender,
        location: location,
        capacity: capacity,
        status: "active"
      }
    )
    (var-set center-nonce new-id)
    (ok new-id)
  )
)

(define-public (record-recycling-batch (center-id uint) (waste-type (string-ascii 20)) (amount uint))
  (let
    ((new-id (+ (var-get batch-nonce) u1))
     (center (unwrap! (map-get? recycling-centers { center-id: center-id }) (err u404))))
    (asserts! (is-eq tx-sender (get operator center)) (err u403))
    (map-set recycling-batches
      { batch-id: new-id }
      {
        center-id: center-id,
        waste-type: waste-type,
        amount: amount,
        timestamp: block-height,
        status: "processed"
      }
    )
    (var-set batch-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-center (center-id uint))
  (map-get? recycling-centers { center-id: center-id })
)

(define-read-only (get-recycling-batch (batch-id uint))
  (map-get? recycling-batches { batch-id: batch-id })
)

