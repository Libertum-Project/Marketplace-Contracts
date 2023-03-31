// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./Ownable.sol";

contract FeeBeneficiary is Ownable {
    uint256 public feePercentage;
    address public feeTo;

    uint256 public feeLiquidity;
    address public liquidity;

    address public poolLiquidityAddress;
    address public houseFounds;
    uint public poolLiquidityMintPercentage;
    uint public houseFoundsPercentage;

    address[] public contractsBeneficiary;
    
    
    modifier onlyContractsBeneficiary() {
        require(_checkContractCaller(msg.sender), "Only contracts beneficiary can call this function");
        _;
    }
    
    constructor(address _feeTo, uint256 _feePercentage) {
        setFee(_feeTo == address(0) ? address(this) : _feeTo, _feePercentage);
    }

    function setFee(address _feeTo, uint256 _feePercentage) public onlyOwner {
        feeTo = _feeTo;
        feePercentage = _feePercentage;
    }
    
    function newAddress(address _feeBeneficiary) public onlyOwner {
        contractsBeneficiary.push(_feeBeneficiary);
    }

    function setFeeLiquidity(address _liquidity, uint256 _feeLiquidity) public onlyOwner {
        liquidity = _liquidity;
        feeLiquidity = _feeLiquidity;
    }

    //function call by marketplaceFixedPrice
    function chargeFeeFixedPrice(
        IERC20 _token, 
        uint256 _totalAmount, 
        address _from
    ) public onlyContractsBeneficiary returns (uint256) {
        uint256 fee = (_totalAmount * feePercentage) / 100;
        uint256 feeLQ = (_totalAmount * feeLiquidity) / 100;

        if (feeTo!= address(this)) {
            _token.transferFrom(_from,feeTo, fee);
        }

        if (liquidity!= address(this)) {
            _token.transferFrom(_from, liquidity, feeLQ);
        }

        uint256 resultingAmount = _totalAmount - fee - feeLQ;
        return resultingAmount;
        
    }

    //function call by marketplaceAuction
    function chargeFeeAuction(
        uint256 _totalAmount, 
        IERC20 _token, 
        address _from
    ) public onlyContractsBeneficiary returns (uint256) {
        uint256 fee = (_totalAmount * feePercentage) / 100;
        uint256 feeLQ = (_totalAmount * feeLiquidity) / 100;

        if (feeTo!= address(this)) {
            _token.transferFrom(_from, feeTo, fee);
        }

        if (liquidity!= address(this)) {
            _token.transferFrom(_from, liquidity, feeLQ);
        }

        uint256 resultingAmount = _totalAmount - fee - feeLQ;
        return resultingAmount;
    }    

    function setMintPercentage(uint _poolLiquidityMintPercentage )public onlyOwner{ 
        poolLiquidityMintPercentage = _poolLiquidityMintPercentage;
        houseFoundsPercentage = 100 - poolLiquidityMintPercentage;
    }

    function setHouseFounds(address _houseFounds)public onlyOwner{ 
        houseFounds = _houseFounds;
    }

    function setPoolLiquidityAddress(address _poolLiquidityAddress)public onlyOwner{ 
        poolLiquidityAddress = _poolLiquidityAddress;
    }

    function _getFeeLiquidity() public view returns(uint){
        return feeLiquidity;
    }

    function _getFee() public view returns(uint){
        return feePercentage;
    }

    function _checkContractCaller(address _caller) internal view returns(bool){
        bool result = false;
        for (uint i = 0; i < contractsBeneficiary.length; i++) {
            if (_caller == contractsBeneficiary[i]) {
                result = true;
            }
        }
        return result;
    }
}
