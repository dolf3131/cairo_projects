#[cfg(test)]
mod tests {
    use age_verifier::IAgeVerifierDispatcher;
    use age_verifier::IAgeVerifierDispatcherTrait;
    use starknet::{ContractAddress, Felt252TryIntoContractAddress};
    use starknet::TryInto;
    use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};
    use core::array::ArrayTrait;
    use core::traits::Into;
    use core::result::ResultTrait;
    use core::option::OptionTrait;

    const THRESHOLD_YEAR: u32 = 2005;

    fn setup() -> IAgeVerifierDispatcher {
        let class = declare("AgeVerifier").unwrap().contract_class();
        
        let owner: ContractAddress = 0_felt252.try_into().unwrap();
        let mut constructor_args = array![owner.into(), THRESHOLD_YEAR.into()];

        let (contract_address, _) = class.deploy(@constructor_args).unwrap();
        
        IAgeVerifierDispatcher { contract_address }
    }

    #[test]
    fn test_verification_success() {
        let dispatcher = setup();
        dispatcher.verify_age(2000);
    }

    #[should_panic(expected: ('Underage',))]
    #[test]
    fn test_verification_fail() {
        let dispatcher = setup();
        dispatcher.verify_age(2010);
    }

    #[test]
    fn test_verification_edge_case() {
        let dispatcher = setup();
        dispatcher.verify_age(2005);
    }
}
