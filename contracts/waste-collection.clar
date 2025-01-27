;; Waste Collection Management Contract

(define-map collection-routes
  { route-id: uint }
  {
    collector: principal,
    area: (string-ascii 100),
    schedule: (string-ascii 50),
    status: (string-ascii 20)
  }
)

(define-map waste-collections
  { collection-id: uint }
  {
    route-id: uint,
    collector: principal,
    timestamp: uint,
    waste-amount: uint,
    waste-type: (string-ascii 20)
  }
)

(define-data-var route-nonce uint u0)
(define-data-var collection-nonce uint u0)

(define-public (create-route (area (string-ascii 100)) (schedule (string-ascii 50)))
  (let
    ((new-id (+ (var-get route-nonce) u1)))
    (map-set collection-routes
      { route-id: new-id }
      {
        collector: tx-sender,
        area: area,
        schedule: schedule,
        status: "active"
      }
    )
    (var-set route-nonce new-id)
    (ok new-id)
  )
)

(define-public (record-collection (route-id uint) (waste-amount uint) (waste-type (string-ascii 20)))
  (let
    ((new-id (+ (var-get collection-nonce) u1))
     (route (unwrap! (map-get? collection-routes { route-id: route-id }) (err u404))))
    (asserts! (is-eq tx-sender (get collector route)) (err u403))
    (map-set waste-collections
      { collection-id: new-id }
      {
        route-id: route-id,
        collector: tx-sender,
        timestamp: block-height,
        waste-amount: waste-amount,
        waste-type: waste-type
      }
    )
    (var-set collection-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-route (route-id uint))
  (map-get? collection-routes { route-id: route-id })
)

(define-read-only (get-collection (collection-id uint))
  (map-get? waste-collections { collection-id: collection-id })
)

