// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./utils/FeeTokenERC20.sol";

contract FeeToken is Ownable, FeeTokenERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    event SetFeeValues(uint256 burnFee, uint256 fundFee);
    event SetFeeTo(address indexed feeTo);
    event AddBlackList(address indexed black);
    event RemoveFromBlackList(address indexed white);
    event TransferWithFee(address indexed from, address indexed to, uint256 amount, uint256 burnAmount, uint256 fundAmount);

    uint256 INITIAL_SUPPLY = 100000000000000000 * 10**18;

    uint256 private _transferFee; // 100% = 10000
    uint256 private _burnFee;     // 100% = 10000
    uint256 private _fundFee;     // 100% = 10000
    address private _feeTo;

    EnumerableSet.AddressSet private _blackList;

    constructor() FeeTokenERC20("Fee Token", "FeeToken") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @dev returns transfer fee, 10000 = 100%
     */
    function totalTransferFee() external view returns (uint256) {
        return _burnFee + _fundFee;
    }

    function feeTo() external view returns (address) {
        return _feeTo;
    }

    function setFeeValues(uint256 __burnFee, uint256 __fundFee) external onlyOwner {
        require(__burnFee + __fundFee <= 1000, "Fee percenated is exceeded limit");
        require(__burnFee != _burnFee || __fundFee != _fundFee, "Already set value");
        emit SetFeeValues(__burnFee, __fundFee);
    }

    function setFeeTo(address _to) external onlyOwner {
        require(_to != _feeTo, "Already set address");
        _feeTo = _to;
        emit SetFeeTo(_to);
    }

    function addBlackList(address _black) external onlyOwner {
        require(!_blackList.contains(_black), "Already listed as black");
        _blackList.add(_black);
        emit AddBlackList(_black);
    }

    function removeFromBlackList(address _white) external onlyOwner {
        require(_blackList.contains(_white), "Not black listed address");
        _blackList.remove(_white);
        emit RemoveFromBlackList(_white);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(!_blackList.contains(from) && !_blackList.contains(to), "Transfer between black listed addresses are not allowed");
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }

        uint256 burnAmount;
        uint256 fundAmount;
        if (_feeTo != address(0)) {
            if (_burnFee != 0) {
                burnAmount = amount * _burnFee / 10000;
                _totalSupply -= burnAmount;
            }
            if (_fundFee != 0) {
                fundAmount = amount * _fundFee / 10000;
                _balances[_feeTo] += fundAmount;
            }
        }

        _balances[to] += amount - burnAmount - fundAmount;

        emit TransferWithFee(from, to, amount, burnAmount, fundAmount);
    } 
}