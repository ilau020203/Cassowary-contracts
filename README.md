# Cassowary

![scheme](./scheme.png)


## Strategy 
One strategy includes two contracts: Logic and Storage.

### Logic
Provides management for admin (oracle) strategy ability to manage depositors tokens
#### Error codes

1 - You can not accept, call only admin or owner
2 - You can not accept, call only Storage
3 - vTokens is not used
4 - Swap is not used
5 - SwapMaster is not used
6 - CSR was set
7 - Storage was set
8 - Venus not listed this vToken

#### Methods
##### getReservesCount  
```
function getReservesCount() 
public view returns(uint)
```

Return count reserves staked lp tokens for return users their tokens.

##### getReserve 
```
function getReserve(uint256 id) 
public view
returns(ReserveLiquidity memory)
```
Return  reserves staked lp tokens for return user their tokens.
return [ReserveLiquidity](Description.md#reserveliquidity)

##### addVTokens 
```
function addVTokens(address token, address vToken) 
external onlyOwner
 ```
Add VToken in Contract and approve token  for storage, venus, pancakeswap/apeswap router, and pancakeswap/apeswap master(Main Staking contract)

##### setCSR 
```
function setCSR(address csr_) 
external onlyOwner 
```
Set csr in contract and approve csr  for storage, venus, pancakeswap/apeswap router, and pancakeswap/apeswap master(Main Staking contract), you can call the function once

##### setStorage
```
 function setStorage(address storage_)
  external onlyOwner 
```
Set storage, you can call the function once

##### approveTokenForSwap  
```
function approveTokenForSwap(address token ) 
onlyOwner external
```
Approve token  for storage, venus, pancakeswap/apeswap router, and pancakeswap/apeswap master(Main Staking contract)

##### returnToken  
```
function  returnToken(uint amount, address token)
  onlyStorage external payable
```
Frees up tokens for the user, but Storage doesn't transfer token for the user, only Storage can this function, after calling this function  Storage transfer from Logic to user token.

##### addReserveReserveLiquidity 
 ```
  function addReserveReserveLiquidity(ReserveLiquidity memory reserveLiquidity )
    onlyOwnerAndAdmin external
 ```
Add  reserve staked lp token to end list

###### ReserveLiquidity
|Name| Type | text |
|---|---|---|
| tokenA  | address  |  tokenA of staked Lp Token |
| tokenB  | address  |  tokenB of staked Lp Token |
| vTokenA  |  address | VTokenA of tokenA  | 
| vTokenB  |  address | VTokenB of tokenB  | 
|  swap |  address | address of apeswap/pancake router  | 
|  swapMaster |  address | address of apeswap/pancake master(Main Staking contract)  | 
|  lpToken |  address | address of lpToken  | 
|  poolID |  uint256 |  poolID of apeswap/pancake master(Main Staking contract) where staked lpToken | 
|  path |   address[][] |  array of  path from token0 to token that use storage | 

##### deleteLastReserveLiquidity
  ```
   function deleteLastReserveLiquidity( )
    onlyOwnerAndAdmin external
   ```
Delete last ReserveLiquidity from list of ReserveLiquidity

##### setAdmin
```
function setAdmin(address newAdmin)
 onlyOwner external 
 ```
Set admin

##### takeTokenFromStorage  
```
 function takeTokenFromStorage(uint amount, address token)
  onlyOwnerAndAdmin external
```
Transfer `amount` of `token` from Storage to Logic contract 
`token` - address of the token, for example if need transfer BUSD then `token` is  `0xe9e7cea3dedca5984780bafc599bd69add087d56`

##### returnTokenToStorage  
```
function returnTokenToStorage(uint amount, address token)  onlyOwnerAndAdmin external  
```
Transfer `amount` of `token` from Logic  to Storage contract 
`token` - address of token, for example if need transfer BUSD then `token` is  `0xe9e7cea3dedca5984780bafc599bd69add087d56`

##### addEarnToStorage
 ```
function addEarnToStorage(uint amount )  
onlyOwnerAndAdmin external 
```
Distribution `amount` of csr to depositors.

##### enterMarkets
```
function enterMarkets(address[] calldata vTokens) 
 onlyOwnerAndAdmin external returns (uint[] memory) 
```
Enter into a list of markets(address of VTokens) - it is not an error to enter the same market more than once. In order to supply collateral or borrow in a market, it must be entered first.
msg.sender: The account which shall enter the given markets.
vTokens: The addresses of the vToken markets to enter.
RETURN: For each market, returns an error code indicating whether or not it was entered. Each is 0 on success, otherwise an [Error code](https://docs.venus.io/docs/unitroller#unitroller-error-codes)

##### claimVenus 
```
 function claimVenus( address[] calldata vTokens)  
  onlyOwnerAndAdmin external 
 ```
Every Venus user accrues XVS for each block they are supplying to or borrowing from the protocol. The protocol automatically transfers accrued XVS to a user’s address when the total amount of XVS accrued that address (in a market) is greater than the claimVenusThreshold,  and the address executes any of the mint, borrow, transfer, liquidateBorrow, repayBorrow, or 
functions on that market. Separately, users may call the claimVenus method on any vToken contract at any time for finer-grained control over which markets to claim from.

RETURN: The liquidationIncentive, scaled by 1e18, is multiplied by the closed borrow amount from the liquidator to determine how much collateral can be seized.


##### mint
```
 function mint(address vToken,uint mintAmount) 
    isUsedVToken(vToken) onlyOwnerAndAdmin external returns (uint) 
```
`vToken`: vToken that mint  Vtokens to this contract

`mintAmount`: The amount of the asset to be supplied, in units of the underlying asset.

RETURN: 0 on success, otherwise an [Error code](https://docs.venus.io/docs/vtokens#vtokens-error-codes)

##### borrow
 ```
function borrow(address vToken,uint borrowAmount)   
 isUsedVToken(vToken) onlyOwnerAndAdmin external payable returns  (uint) 
 ```
The borrow function transfers an asset from the protocol to the user and creates a borrow balance which begins accumulating interest based on the Borrow Rate for the asset. The amount borrowed must be less than the user's Account Liquidity and the market's available liquidity.

`vToken`: vToken that mint  Vtokens to this contract

`redeemAmount`: The amount of underlying to be redeemed.

RETURN: 0 on success, otherwise an [Error code](https://docs.venus.io/docs/vtokens#vtokens-error-codes)


##### redeemUnderlying 
```
 function redeemUnderlying(address vToken,uint redeemAmount)
    isUsedVToken(vToken) onlyOwnerAndAdmin external returns (uint)
 ```
The redeem underlying function converts vTokens into a specified quantity of the underlying asset, and returns them to the user. The amount of vTokens redeemed is equal to the quantity of underlying tokens received, divided by the current Exchange Rate. The amount redeemed must be less than the user's Account Liquidity and the market's available liquidity.

`vToken`: vToken that mint  Vtokens to this contract


`redeemAmount`: The amount of underlying to be redeemed.

RETURN: 0 on success, otherwise an [Error code](https://docs.venus.io/docs/vtokens#vtokens-error-codes)


##### repayBorrow 
```
 function repayBorrow(address vToken,uint repayAmount)  
    isUsedVToken(vToken) onlyOwnerAndAdmin external returns (uint)
 ```
The repay function transfers an asset into the protocol, reducing the user's borrow balance.

`vToken`: vToken that mint  Vtokens to this contract

`borrowAmount`: The amount of the underlying borrowed asset to be repaid. A value of -1 (i.e. 2256 - 1) can be used to repay the full amount.

RETURN: 0 on success, otherwise an [Error code](https://docs.venus.io/docs/vtokens#vtokens-error-codes)

##### addLiquidity
``` 
function addLiquidity(
        address swap,
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        uint deadline
    ) isUsedSwap(swap) external returns (uint amountA, uint amountB, uint liquidity)
```
Adds liquidity to a BEP20⇄BEP20 pool.
|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| tokenA  | address  |  The contract address of one token from your liquidity pair.|
| tokenB  | address  | The contract address of the other token from your liquidity pair. |
| amountADesired  |  uint |The amount of tokenA you'd like to provide as liquidity.  | 
| amountBDesired  |  uint |The amount of tokenA you'd like to provide as liquidity.  | 
|  amountAMin |  uint | The minimum amount of tokenA to provide (slippage impact).  | 
|  amountBMin |  uint |The minimum amount of tokenB to provide (slippage impact).  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. | 


#####  removeLiquidity
```
 function removeLiquidity(
         address swap,
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        uint deadline
    ) isUsedSwap(swap)  external returns (uint amountA, uint amountB)
```
Removes liquidity from a BEP20⇄BEP20 pool.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| tokenA  | address  |  The contract address of one token from your liquidity pair.|
| tokenB  | address  | The contract address of the other token from your liquidity pair. |
| liquidity  |  uint | The amount of LP Tokens to remove.  | 
|  amountAMin |  uint | he minimum amount of tokenA to provide (slippage impact). | 
|  amountBMin |  uint |The minimum amount of tokenB to provide (slippage impact).  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. | 



#####  swapExactTokensForTokens
```
  function swapExactTokensForTokens(
        address swap,
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        uint deadline
    ) isUsedSwap(swap) external returns (uint[] memory amounts)
```
Receive an as many output tokens as possible for an exact amount of input tokens.
|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| amountIn  | uint  |  TPayable amount of input tokens.|
| amountOutMin  | uint  | The minimum amount tokens to receive. |
| path (address[]) |  address | An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. |

#####  swapTokensForExactTokens
```
function swapTokensForExactTokens(
        address swap,
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        uint deadline
    ) isUsedSwap(swap) external returns (uint[] memory amounts)
```
Receive an exact amount of output tokens for as few input tokens as possible.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| amountOut  | uint  |  Payable amount of input tokens.|
| amountInMax  | uint  | The minimum amount tokens to input. |
| path (address[]) |  address | An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. |

#####  addLiquidityETH
```
function addLiquidityETH(
         address swap,
        address token,
        uint amountTokenDesired,
        uint amountETHDesired,
        uint amountTokenMin,
        uint amountETHMin,
        uint deadline
    )isUsedSwap(swap) onlyOwnerAndAdmin external  returns (uint amountToken, uint amountETH, uint liquidity)
```

Adds liquidity to a BEP20⇄WBNB pool.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| token  | address  |  The contract address of one token from your liquidity pair.|
| amountTokenDesired  |  uint |The amount of the token you'd like to provide as liquidity.  | 
| amountETHDesired  |  uint |The minimum amount of the token to provide (slippage impact). | 
|  amountTokenMin |  uint | The minimum amount of token to provide (slippage impact). | 
|  amountETHMin |  uint |The minimum amount of BNB to provide (slippage impact).  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. | 


#####  removeLiquidityETH
```
  function removeLiquidityETH(
          address swap,
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        uint deadline
    )isUsedSwap(swap) onlyOwnerAndAdmin external payable returns (uint amountToken, uint amountETH)
```
Removes liquidity from a BEP20⇄WBNB pool.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| token  | address  |  The contract address of one token from your liquidity pair.|
| liquidity  |  uint | The amount of LP Tokens to remove.  | 
|  amountTokenMin |  uint | The minimum amount of the token to remove (slippage impact). | 
|  amountETHMin |  uint |The minimum amount of BNB to remove (slippage impact). | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. | 


#####  swapExactETHForTokens
```
  function swapExactETHForTokens(address swap,uint amountETH,uint amountOutMin, address[] calldata path,  uint deadline)
    isUsedSwap(swap) onlyOwnerAndAdmin
    external
    returns (uint[] memory amounts)
```
Receive  as many output tokens as possible for an exact amount of BNB.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| amountETH  | uint  |   Payable BNB amount.|
| amountOutMin  | uint  | The minimum amount tokens to input. |
| path (address[]) |  address | An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. |



#####  swapTokensForExactETH
```
 function swapTokensForExactETH(address swap,uint amountOut, uint amountInMax, address[] calldata path,  uint deadline)
    isUsedSwap(swap) onlyOwnerAndAdmin 
    external payable
    returns (uint[] memory amounts)
```
Receive an exact amount of output tokens for as few input tokens as possible.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| amountOut  | uint  |  Payable BNB amount.|
| amountInMax  | uint  | The minimum amount tokens to input. |
| path (address[]) |  address | An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. |



#####  swapExactTokensForETH
```
function swapExactTokensForETH(address swap,uint amountIn, uint amountOutMin, address[] calldata path,  uint deadline)
    isUsedSwap(swap) onlyOwnerAndAdmin
    external payable
    returns (uint[] memory amounts)
```
Receive  as much BNB as possible for an exact amount of input tokens.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| amountIn  | uint  |  Payable amount of input tokens.|
| amountOutMin  | uint  | The maximum amount tokens to input. |
| path (address[]) |  address | An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. |



#####  swapETHForExactTokens
```
 function swapETHForExactTokens(address swap,uint amountETH,uint amountOut, address[] calldata path,  uint deadline)
        isUsedSwap(swap) onlyOwnerAndAdmin
        external 
        returns (uint[] memory amounts)
```
Receive an exact amount of output tokens for as little BNB as possible.

|Name| Type | text |
|---|---|---|
| swap  | address  | Address of swap router|
| amountOut  | uint  | The amount tokens to receive.|
| amountETH  | uint  | Payable BNB amount. |
| path (address[]) |  address | An array of token addresses. path.length must be >= 2. Pools for each consecutive pair of addresses must exist and have liquidity.  | 
|  deadline |  uint |  Unix timestamp deadline by which the transaction must confirm. |


#####  deposit
```
    function deposit(address swapMaster,uint256 _pid, uint256 _amount) 
    isUsedMaster(swapMaster) onlyOwnerAndAdmin external
```
 Deposit LP tokens to Master
|Name| Type | text |
|---|---|---|
| swapMaster  | address  | Address of swap master(Main staking contract)|
| _pid  | uint  | pool id|
| _amount  | uint  | amount of lp token|



#####  withdraw
```
 function withdraw(address swapMaster,uint256 _pid, uint256 _amount)
    isUsedMaster(swapMaster) onlyOwnerAndAdmin external
```
Withdraw LP tokens from Master
|Name| Type | text |
|---|---|---|
| swapMaster  | address  | Address of swap master(Main staking contract)|
| _pid  | uint  | pool id|
| _amount  | uint  | amount of lp token|

#####  leaveStaking
```
 function leaveStaking(address swapMaster,uint256 _amount)
    isUsedMaster(swapMaster) onlyOwnerAndAdmin external
```
Withdraw BANANA/Cake tokens from STAKING.
|Name| Type | text |
|---|---|---|
| swapMaster  | address  | Address of swap master(Main staking contract)|
| _amount  | uint  | amount of lp token|



#####  enterStaking
```
 function enterStaking(address swapMaster,uint256 _amount)
    isUsedMaster(swapMaster) onlyOwnerAndAdmin external
```
Stake BANANA/Cake tokens to STAKING.
|Name| Type | text |
|---|---|---|
| swapMaster  | address  | Address of swap master(Main staking contract)|
| _amount  | uint  | amount of lp token|





#### Storage 
`Storage.sol` - not updable contract
`StorageV0.sol` - updable contract
`StorageV1.sol`, `StorageV2.sol`- updable contract for test update contract
For update contract read [openzepellin docs](https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable) and check with `truffle-upgrades` version compatibility
Interacts with users, distributes earned CSR, and associates with Logic contract.
#### Methods


#####  deposit
```
    function deposit(uint256 amount, address token)
    isUsedToken(token) whenNotPaused external
```
Deposit `amount` of `token`  to Strategy  and receiving earned tokens.
|Name| Type | text |
|---|---|---|
| amount  | uint256  | amount of token|
| token  | token  | address of token|






#####  withdraw
```
 function withdraw(uint256 amount, address token)
    isUsedToken(token) whenNotPaused external
```
Withdraw `amount` of `token`  from Strategy and receiving earned tokens.
|Name| Type | text |
|---|---|---|
| amount  | uint256  | amount of token|
| token  | token  | address of token|




#####  interestFee
```
  function interestFee()
    external
```
Claim CSR



#####  setCSR
```
function setCSR(address _csr)
    onlyOwner  external
```
Set csr in contract

#####  setLogic
```
 function setLogic(address _logic)
 onlyOwner  external
```
Set logic in contract(only for upgradebale contract,use only whith DAO)

#####  pause
```
    function pause()
    onlyOwner  external
```
Triggers stopped state.




#####  unpause
```
  function unpause()
  onlyOwner  external
```
Returns to normal state.


#####  addToken
```
 function addToken(address _token,address _oracles) 
    onlyOwner  external
```
Add token and token's oracle
|Name| Type | text |
|---|---|---|
| _token  | address  | Address of Token|
| _oracles  | address  | [Address of token's oracle](https://docs.chain.link/docs/binance-smart-chain-addresses/)|




#####  takeToken
```
  function takeToken(uint amount, address token) 
    isLogicContract(msg.sender) isUsedToken(token) external
```
Transfer `amount` of `token` from Storage to Logic Contract.





#####  returnToken
```
  function returnToken(uint amount, address token)
    isLogicContract(msg.sender) isUsedToken(token) external
```
Transfer `amount` of `token` from Logic to Storage Contract.





#####  addEarn
```
 function addEarn(uint256 amount)
    isLogicContract(msg.sender) external
```
Take `amount` CSR from Logic contract  and distributes earned CSR





#####  _upBalance
```
  function _upBalance(address account)
    public
```
Counts the number of accrued СSR 




#####  _upBalanceByIteration
```
 function _upBalanceByIteration(address account,uint256 iterate)
    public
```
Counts the number of accrued СSR by `iterate` 





#####  balanceEarnCSR
```
    function balanceEarnCSR(address account) view public returns(uint256)
```
Return earned csr




#####  balanceOf
```
function balanceOf(address account) view public returns (uint256)
```
Return usd balance of `account` 



#####  getCSRReserve
```
function getCSRReserve( ) view public returns (uint256) 
```
Return sums of all distribution CSR.



#####  getTotalDeposit
```
 function getTotalDeposit( ) view public returns (uint256) 
```
Return deposited usd




#####  getTokenBalance
```
 function getTokenBalance(address token) view public returns (uint256)
```
Returns the balance of `token` on this contract




#####  getTokenDeposit
```
  function getTokenDeposit(address account,address token) view public returns (uint256)
```
Return deposited `token` from `account` 


#####  getCountEarns
```
 function getCountEarns() view public returns(uint)
```
Return count distribution CSR token.

#####  getEarnsByID
```
  function getEarnsByID(uint id) view public returns(uint,uint,uint)
```
Return data on distribution CSR token.
First return value is amount of distribution CSR token.
Second return value is a timestamp when  distribution CSR token completed.
Third return value is an amount of dollar depositedhen  distribution CSR token completed.

#####  getTokenDeposited
```
  function getTokenDeposited(address token) view public returns (uint256) 
```
Return amount of all deposited `token` 

## Sale and Vesting CSR

### Private Sale
Can create rounds in which investors can buy tokens receiving them by vesting
#### Methods
#####  deposit
```
  function deposit(uint256 amount, address token)
    isUsedToken(token) unfinishedRound  external 
```
Deposit `amount` of `token` for buy csr.

#####  returnDeposit
```
    function returnDeposit(uint256 round)
    external
```
Returns a deposit for the  `round`

#####  addToken
```
    function addToken(address _token,address _oracles) 
    onlyOwner  external
```
Add token and token's oracle
|Name| Type | text |
|---|---|---|
| _token  | address  | Address of Token|
| _oracles  | address  | [Address of token's oracle](https://docs.chain.link/docs/binance-smart-chain-addresses/)|



#####  setInvestorWallet
```
  function setInvestorWallet(address _investorWallet)
    onlyOwner finishedRound external
```
Set investor wallet

#####  setExpenseAddress
```
 function setExpenseAddress(address _expenseAddress)
    onlyOwner finishedRound external
```
Set Expense Address

#####  setExpenseAddressAndInvestorWallet
```
    function setExpenseAddressAndInvestorWallet(address _expenseAddress,address _investorWallet)
    onlyOwner finishedRound external
```
Set investor wallet and Expense Address

#####  setCSR
```
  function setCSR(address _CSR)
    onlyOwner  external
```
Set csr in contract 

#####  newRound
```
    function newRound(
       InputNewRound memory input)
    onlyOwner  finishedRound external
```
Create new round
Parameters [InputNewRound](Description.md#inputnewround)
#####  setRateToken
```
 function setRateToken(uint256 rate)
    onlyOwner unfinishedRound  external 
```
Set Rate Token

#####  setEndTimestamp
```
  function setEndTimestamp(uint256 _endTimestamp)
    onlyOwner unfinishedRound  external
```
Set End Timestamp

#####  setSumTokens
```
 function setSumTokens(uint256 _sumTokens)
    onlyOwner unfinishedRound external
```
Set Sum Tokens


#####  setSumTokens
```
 function setSumTokens(uint256 _sumTokens)
    onlyOwner unfinishedRound external
```
Set Sum Tokens



#####  setStartTimestamp
```
  function setStartTimestamp(uint256 _startTimestamp)
    onlyOwner unfinishedRound external
```
Set  Start Timestamp



#####  setMaxMoney
```

    function setMaxMoney(uint256 _maxMoney)
    onlyOwner unfinishedRound external
```
Set Max Money



#####  addWhiteList
```
 function addWhiteList(address account)
    onlyOwner unfinishedRound external 
```
Add `account` in white list


#####  addWhiteListByArray
```
  function addWhiteListByArray(address[] calldata accounts)
    onlyOwner unfinishedRound external 
```
Add array of `accounts` in white list



#####  deleteWhiteList
```
 function deleteWhiteList(address account)
    onlyOwner unfinishedRound  external 
```
Delete `account` from white list



#####  deleteWhiteListByArray
```
 function deleteWhiteListByArray(address[] calldata accounts)
    onlyOwner unfinishedRound external 
```
Delete array of `accounts` from white list



#####  finishRound
```
 function finishRound() 
    onlyOwner  external
```
Finish round



#####  cancelRound
```
 function cancelRound()
    onlyOwner  external
```
Cancel round


#####  getRoundStateInfromation
```
 function getRoundStateInfromation(uint256 id) view public returns (InputNewRound memory )
```
Return  [InputNewRound](Description.md#reserveliquidity)


#####  getLockedTokens
```
function getLockedTokens(uint256 id) view public returns (
        uint256
    )
```
Returns Locked Tokens


#####  getRoundDynamicInfromation
```
 function getRoundDynamicInfromation(uint256 id) view public returns ( uint256 ,
        uint256 ,
        bool 
    ) 
```
Returns (all deposited money, sold tokens, open or close round)

#####  isInWhiteList
```
function isInWhiteList(address account) view public returns (bool)
```
Return true if `account`  is in white list

#####  getCountRound
```
    function getCountRound() view public returns ( uint256)
```
Return count round


#####  getVestingAddress
```
  function getVestingAddress(uint256 id) existRound(id)  view public returns ( address) 
```
Return address Vesting contract

#####  getInvestorDepositedTokens
```
function getInvestorDepositedTokens(uint256 id, address account) existRound(id)  view public returns ( uint256) 
```
Return Investor Deposited Tokens 

#####  isInWhiteList
```
function isInWhiteList(address account) view public returns (bool)
```
Return true if `account`  is in white list

#####  getInvestorWallet
```
 function getInvestorWallet()  view public returns  ( address) 
```
Return Investor Wallet

#####  isCancelled
```
function isCancelled(uint256 id) existRound(id) view public returns  ( bool)
```
Return true if `id` round is cancelled

#####  isParticipatedInTheRound
```
function isParticipatedInTheRound(uint256 id) existRound(id)  view public returns ( bool)
```
Return true if `msg.sender`  is Participated In The Round

#####  getUserToken
```
 function getUserToken(uint256 id) existRound(id)  view public returns ( address)
```
Return deposited token addres of `msg.sender`

#####  isFinished
```
function isFinished(uint256 id) view public returns (bool) 
```
Return true if `id` round  is finished


#### Structs
##### InputNewRound
|Name| Type | text |
|---|---|---|
| _tokenRate  | uint256  |CSR/USD if type round 1, 0 if  type round 2|
| _maxMoney  | uint256 |Amount USD when close round|
| _sumTokens  | uint256  |Amount of selling CSR. Necessarily with the type of round 2 |
| _startTimestamp  |  uint256 | Unix timestamp  Start Round  | 
|  _endTimestamp |  uint256 | Unix timestamp  End Round    | 
|  _minimumSaleAmount |  uint256 |minimum sale amount  | 
|  _maximumSaleAmount |  uint256 |maximum sale amount  | 
|  _duration |  uint256 | Vesting duration period | 
|  _durationCount |  uint256 | Count of Vesting duration period | 
|  _lockup |  uint256 | duration from end round to start vesting | 
|  _typeRound |  uint8 |  if 1 rate set, if 2 dynamic rate, if 0 canceled round  | 
|  _percentOnInvestorWallet |  uint8 |  percent OnI nvestor Wallet | 
|  _burnable |  bool | if true then `_sumTokens`-selled csr burn  | 
|  _open |  bool | if false only  account from white list can deposit  | 
```
 struct InputNewRound{
        uint256 _tokenRate;
        uint256 _maxMoney;
        uint256 _sumTokens;
        uint256 _startTimestamp;
        uint256 _endTimestamp;
        uint256 _minimumSaleAmount;
        uint256 _maximumSaleAmount;
        uint256 _duration;
        uint256 _durationCount;
        uint256 _lockup;
        uint8 _typeRound;
        uint8 _percentOnInvestorWallet;
        bool _burnable;
        bool _open;
    }
```


### TokenVesting
Vest erc20 to alone address 

#### Methods


#####  constructor
```
 constructor (address tokenValue,
    address beneficiaryValue,
    uint256 startTimestampValue, 
    uint256 durationValue,
    uint256 durationCountValue)
```
Creates a vesting contract that vests the balance of any ERC20 token to the beneficiary. By then all of the balance will have vested

#####  beneficiary
```
 function beneficiary() public view returns (address)
```
Return the beneficiary of the tokens.

#####  end
```
    function end() public view returns (uint256) 
```
Return the end time of the token vesting.

#####  start
```
 function start() public view returns (uint256) 
```
Return the start time of the token vesting.

#####  duration
```
 function duration() public view returns (uint256)
```
Return the duration of the token vesting.

#####  released
```
 function released() public view returns (uint256)
```
Return the amount of the token released.

#####  releasableAmount
```
    function releasableAmount() public view returns (uint256) 
```
Calculates the amount that has already been vested but hasn't been released yet.

#####  _vestedAmount
```
function _vestedAmount() private view returns (uint256)
```
Calculates the amount that has already been vested.

### TokenVestingGroup
Vest erc20 to a group address 

#### Methods

#####  constructor
```
 constructor (address tokenValue,   
    uint256 durationValue,
    uint256 durationCountValue,
    address[] memory tokensValue
    )  
```
|Name| Type | text |
|---|---|---|
| tokenValue  | address  |address of token distriburion|
| durationValue  | uint256 | Vesting duration period |
| durationCountValue  | uint256  |Count of Vesting duration period  |
| tokensValue  |   address[]  | address of tokens   | 

#####  deposit
```
 function deposit(address user, address token, uint256 amount )
    onlyOwner external
```
Set `token `  and `amount` for `user` 

#####  finishRound
```
    function finishRound(uint256 startTimestampValue,uint256[] memory tokenRate)
    onlyOwner external
```
Finish round 

#####  claim
```
    function claim()
    external
```
Transfers vested tokens to the beneficiary.

#####  returnDeposit
```
    function returnDeposit(address user)
    onlyOwner  external
```
Set `0` deposited tokens for `user` 

#####  end
```
    function end() public view returns (uint256) 
```
Return the end time of the token vesting.

#####  start
```
 function start() public view returns (uint256) 
```
Return the start time of the token vesting.

#####  duration
```
 function duration() public view returns (uint256)
```
Return the duration of the token vesting.

#####  released
```
 function released() public view returns (uint256)
```
Return the amount of the token released.

#####  releasableAmount
```
    function releasableAmount() public view returns (uint256) 
```
Calculates the amount that has already vested but hasn't been released yet.

#####  _vestedAmount
```
function _vestedAmount() private view returns (uint256)
```
Calculates the amount that has already vested.





### VestingController
Storage erc20 and deploy vesting contract

#### Methods

#####  vest
```
function vest(address account,
    uint256 amount,
    uint256 startTimestamp, 
    uint256 duration,
    uint256 durationCount )
    external vestTime onlyOwner
```
Deploy TokenVesting with this parameters 

#####  timestampCreated

```
 function timestampCreated()public view returns(uint256)
```
Returns the start timestamp day when create contract

#####  addCSR

```
  function addCSR(address token)
    external vestTime onlyOwner
```
Add Vesting token
