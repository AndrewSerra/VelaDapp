// SPDX-License-Identifier: GPL-3.0 License
pragma solidity ^0.8.0;

/*
 * @title A store contract to manage coupon sales
 * @author Vela
 */
contract Store {
    string private name;
    address private storeOwner;
    uint private couponSaleCount = 0;
    CouponSale[] public couponSales;

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
        storeOwner = msg.sender;
    }

    /*
     * @descr Returns the count of all sales that have been created
     */
    function getActiveSalesCount() external view returns (uint) {
        return couponSaleCount;
    }

    /*
     * @descr Creates a sales group with the given amount of availability of coupons
     * @param _name - Name of the store creating the contract
     */
    function createSalesGroup(
        string calldata _description, 
        uint _worth, 
        uint _price, 
        uint _availabilityCount, 
        bool _active) public {
        couponSales[couponSaleCount] = CouponSale(
            couponSaleCount,
            _description,
            _worth,
            _price,
            _availabilityCount,
            _active,
            new Coupon[](_availabilityCount)
        );
        _createSaleCoupons(couponSales[couponSaleCount], msg.sender);
        
        emit CouponSalesCreated(
            couponSaleCount, 
            _description, 
            _worth, 
            _price,
            _availabilityCount, 
            _active, 
            couponSales[couponSaleCount].coupons);
        
        couponSaleCount++;
    }

    /*
     * @descr Internal function to generate the gibven amount of coupons for a sale
     * @param _sale - CouponSales object that has been created
     * @param _sender - address of the account that owns the sale
     */
    function _createSaleCoupons(CouponSale storage _sale, address _sender) private {
        require(_sender == storeOwner);

        for(uint i=0; i < _sale.availabilityCount; i++) {
            _sale.coupons.push(Coupon(i, false, payable(_sender)));
        }
    }
}