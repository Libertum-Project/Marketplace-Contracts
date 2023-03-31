// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./IERC20.sol";
import "./Ownable.sol";

interface FeeBeneficiary  {
    //todo: getFeesVariables
    function getFee() external view returns(uint);
    function setFee(address _feeTo, uint256 _feePercentage) external;
    function getFeeLiquidity() external view returns(uint);
    function setFeeLiquidity(address _liquidity, uint256 _feeLiquidity) external;

    function chargeFeeFixedPrice(IERC20 _token, uint256 _totalAmount, address _from) external returns (uint256); 
    function chargeFeeAuction(uint256 _totalAmount, IERC20 _token, address _from) external returns (uint256);
    function tranferFoundOfMint(uint _amount, IERC20 _token, address _from) external;
}
