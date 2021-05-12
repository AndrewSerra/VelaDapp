// SPDX-License-Identifier: GPL-3.0 License
pragma solidity ^0.8.0;

/*
@title A store contract to manage coupon sales
@author Vela
*/
contract Store {
    string private name;
    uint private couponSaleCount = 0;
    mapping (uint => CouponSale) public couponSales;

    // 
    struct CouponSale {
        uint id;
        string description;
        uint worth;
        uint price;
        uint availabilityCount;
        bool active;
        Coupon[] coupons;
    }

    struct Coupon {
        uint id;
        bool purchased;
        address payable owner;
    }

    constructor(string memory _name) {
        name = _name;
    }
}