// SPDX-License-Identifier: GPL-3.0 License
pragma solidity ^0.8.0;

/*
 * @title A store contract to manage coupon sales
 * @author Vela
 */
contract Store {
    string private name;
    uint private couponSaleCount = 0;
    mapping (uint => CouponSale) public couponSales;

    // Coupon Sales that keep a collection of coupons available
    struct CouponSale {
        uint id;
        string description;
        uint worth;
        uint price;
        uint availabilityCount;
        bool active;
        Coupon[] coupons;
    }

    // Individual coupons for a sale collection
    struct Coupon {
        uint id;
        bool purchased;
        address payable owner;
    }

    // Create new coupons sales group
    event CouponSalesCreated(
        uint id,
        string description,
        uint worth,
        uint price,
        uint availabilityCount,
        bool active,
        Coupon[] coupons
    );

    // End of coupon sales group
    event CouponSalesEnd(
        uint id,
        string description,
        bool active
    );

    /*
     * @descr Contructor of the Store, manage coupon sales
     * @param _name - Name of the store creating the contract
     */
    constructor(string memory _name) {
        name = _name;
    }

    function getActiveSalesCount() external view returns (uint) {
        return couponSaleCount;
    }


}