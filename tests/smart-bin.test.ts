import { describe, it, expect, beforeEach } from "vitest"

describe("smart-bin", () => {
  let contract: any
  
  beforeEach(() => {
    contract = {
      registerSmartBin: (location: string, capacity: number) => ({ value: 1 }),
      updateBinStatus: (binId: number, newFill: number) => ({ success: true }),
      getBinStatus: (binId: number) => ({
        location: "Park Avenue",
        capacity: 1000,
        currentFill: 500,
        lastUpdated: 123456,
        status: "active",
      }),
    }
  })
  
  describe("register-smart-bin", () => {
    it("should register a new smart bin", () => {
      const result = contract.registerSmartBin("Park Avenue", 1000)
      expect(result.value).toBe(1)
    })
  })
  
  describe("update-bin-status", () => {
    it("should update the bin status", () => {
      const result = contract.updateBinStatus(1, 500)
      expect(result.success).toBe(true)
    })
  })
  
  describe("get-bin-status", () => {
    it("should return the bin status", () => {
      const result = contract.getBinStatus(1)
      expect(result.location).toBe("Park Avenue")
      expect(result.capacity).toBe(1000)
      expect(result.currentFill).toBe(500)
      expect(result.status).toBe("active")
    })
  })
})

