# wLBC - Wrapped LBRY Credits

A Foundry-based Solidity project implementing an ERC20 token for Wrapped LBRY Credits (wLBC).

## Overview

wLBC is an ERC20 token that represents wrapped LBRY Credits, providing standard Ethereum token functionality including minting, burning, and transfer capabilities. The contract is built using OpenZeppelin's battle-tested libraries and follows modern Solidity development practices.

## Features

- **ERC20 Compliant**: Full ERC20 standard implementation
- **Mintable**: Owner can mint new tokens
- **Burnable**: Tokens can be burned to reduce supply
- **Batch Operations**: Efficient batch minting for multiple recipients
- **Ownable**: Administrative functions restricted to contract owner
- **8 Decimals**: Matches LBRY Credits decimal precision

## Token Details

- **Name**: Wrapped LBRY Credits
- **Symbol**: wLBC
- **Decimals**: 8 (matches LBRY Credits)
- **Initial Supply**: Configurable (default: 21,000,000 tokens)
- **Max Supply**: No hard cap (controlled by owner)

## Development

### Prerequisites

- [Foundry](https://getfoundry.sh/) - Ethereum development toolkit

### Installation

```bash
# Clone the repository
git clone https://github.com/bitcoinbrisbane/wLBC.git
cd wLBC

# Install dependencies
forge install
```

### Building

```bash
# Compile contracts
forge build
```

### Testing

```bash
# Run tests
forge test

# Run tests with gas reports
forge test --gas-report

# Run tests with coverage
forge coverage
```

### Deployment

#### Local Development

```bash
# Start local blockchain
anvil

# Deploy to local network
forge script script/DeploywLBC.s.sol --rpc-url http://localhost:8545 --private-key <PRIVATE_KEY> --broadcast
```

#### Testnet/Mainnet

```bash
# Deploy with environment variables
INITIAL_SUPPLY=21000000 TOKEN_DECIMALS=8 forge script script/DeploywLBC.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

### Environment Variables

- `INITIAL_SUPPLY`: Initial token supply (default: 21,000,000)
- `TOKEN_DECIMALS`: Number of decimal places (default: 8)
- `RPC_URL`: Blockchain RPC endpoint
- `PRIVATE_KEY`: Deployer private key
- `ETHERSCAN_API_KEY`: For contract verification

## Contract API

### Core Functions

#### `mint(address to, uint256 amount)`
Mints tokens to a specified address. Only callable by owner.

#### `batchMint(address[] recipients, uint256[] amounts)`
Mints tokens to multiple addresses in a single transaction. Only callable by owner.

#### `burn(uint256 amount)`
Burns tokens from caller's balance.

#### `burnFrom(address account, uint256 amount)`
Burns tokens from specified account (requires approval).

### View Functions

#### `name()` → `string`
Returns "Wrapped LBRY Credits"

#### `symbol()` → `string`
Returns "wLBC"

#### `decimals()` → `uint8`
Returns the number of decimals (8)

#### `totalSupply()` → `uint256`
Returns total token supply

#### `balanceOf(address account)` → `uint256`
Returns token balance of an account

## Testing

The project includes comprehensive tests covering:

- Basic ERC20 functionality (transfer, approve, transferFrom)
- Minting and burning operations
- Batch minting functionality
- Access control (owner-only functions)
- Edge cases and error conditions
- Fuzz testing for robust validation

### Test Coverage

```bash
# Generate detailed coverage report
forge coverage --report lcov
```

## Security Considerations

- **Access Control**: Administrative functions are protected by OpenZeppelin's Ownable pattern
- **Integer Overflow**: Solidity 0.8+ provides built-in overflow protection
- **Reentrancy**: Standard ERC20 implementation prevents reentrancy attacks
- **Input Validation**: Proper validation for all public functions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/) for secure smart contract libraries
- [Foundry](https://getfoundry.sh/) for the development framework
- [LBRY](https://lbry.com/) for the original LBRY Credits token
