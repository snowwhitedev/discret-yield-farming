## My fixes
- Some wrong openzeppelin links which occurs compile error
- Some unnecessary constructor visibility
- Some interface functions which was not implement in contract and leads compile error
- Some errors

## Comments
- Users can get rewards based on staking amount and staking period.
Admin can control and deposit amount into StakingRewards contract for certain period through factory contract

## Rinkeby deployment
- FeeToken (0xc20d9bd10Fe015C9d1a69B2A5739B248fab7f8e7), skipping.
- StakingRewardsFactory (0x35C581b2B121086530e9E664617710c6d1d45CC8), skipping.
- StakingRewards 0xD19e85F32E2036437ceA4E6802E25d76B72bbCF1