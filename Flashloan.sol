//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./interface/ILendingPoolAddressesProvider.sol";
import "./interface/ILendingPool.sol";
import "./interface/IFlashLoanReceiver.sol";
import "./interface/IERC20.sol";

contract FlashLoan is IFlashLoanReceiver {
    ILendingPoolAddressesProvider public provider;
    ILendingPool public pool;

    event LendingPool(ILendingPool addr);

    constructor() {
        provider = ILendingPoolAddressesProvider(0x5E52dEc931FFb32f609681B8438A51c675cc232d);
        pool = ILendingPool(provider.getLendingPool());
        emit LendingPool(pool);
    }

    function executeOperation(   
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
        ) external override returns(bool) {
        for (uint i = 0; i < assets.length; i++) {
            uint amountOwned = amounts[i] + premiums[i];
            IERC20(assets[i]).approve(address(pool), amountOwned);
        }
        
        return true;
    }

    function flashLoan(address[] calldata assets, uint256[] calldata amounts, uint256[] calldata modes) external {
        // IERC20(assets[0]).approve(address(pool), amounts[0]);
        pool.flashLoan(address(this), assets, amounts, modes, address(this), "", 0);
    }
    // DAI, LINK, AAVE, UNI
    // ["0x75Ab5AB1Eef154C0352Fc31D2428Cef80C7F8B33","0x7337e7FF9abc45c0e43f130C136a072F4794d40b","0x0B7a69d978DdA361Db5356D4Bd0206496aFbDD96","0x981D8AcaF6af3a46785e7741d22fBE81B25Ebf1e"]
    // [100000000000000000,100000000000000000,100000000000000000,100000000000000000]
    // [0,0,0,0]


}