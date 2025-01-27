;; Citizen Rewards Contract

(define-fungible-token recycling-points)

(define-map user-points
  { user: principal }
  { points: uint }
)

(define-constant POINTS-PER-KG u10)

(define-public (award-points (user principal) (waste-amount uint))
  (let
    ((points-to-award (* waste-amount POINTS-PER-KG)))
    (match (map-get? user-points { user: user })
      existing-points (map-set user-points
        { user: user }
        { points: (+ (get points existing-points) points-to-award) })
      (map-set user-points
        { user: user }
        { points: points-to-award }))
    (ft-mint? recycling-points points-to-award user)
  )
)

(define-public (redeem-points (amount uint))
  (let
    ((user-balance (default-to u0 (get points (map-get? user-points { user: tx-sender })))))
    (asserts! (>= user-balance amount) (err u1))
    (try! (ft-burn? recycling-points amount tx-sender))
    (map-set user-points
      { user: tx-sender }
      { points: (- user-balance amount) })
    (ok true)
  )
)

(define-read-only (get-user-points (user principal))
  (default-to u0 (get points (map-get? user-points { user: user })))
)

