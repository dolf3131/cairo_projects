#[starknet::interface]
trait IAgeVerifier<TContractState> {
    fn verify_age(self: @TContractState, birth_year: u32);
    fn get_threshold_year(self: @TContractState) -> u32;
}

#[starknet::contract]
mod AgeVerifier {
    use starknet::ContractAddress;
    // 컴파일러가 제안한 트레이트를 직접 가져옵니다.
    use starknet::storage::StoragePointerReadAccess;
    use starknet::storage::StoragePointerWriteAccess;

    #[storage]
    struct Storage {
        threshold_year: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress, year: u32) {
        self.threshold_year.write(year);
    }

    #[abi(embed_v0)]
    impl AgeVerifierImpl of super::IAgeVerifier<ContractState> {
        fn verify_age(self: @ContractState, birth_year: u32) {
            let threshold = self.threshold_year.read();
            assert(birth_year <= threshold, 'Underage');
        }

        fn get_threshold_year(self: @ContractState) -> u32 {
            self.threshold_year.read()
        }
    }
}
