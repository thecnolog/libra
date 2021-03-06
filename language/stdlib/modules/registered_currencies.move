address 0x0 {

module RegisteredCurrencies {
    use 0x0::LibraConfig;
    use 0x0::Signer;
    use 0x0::Transaction;
    use 0x0::Vector;

    // An on-chain config holding all of the currency codes for registered
    // currencies. Must be named "T" for an on-chain config.
    struct T {
        currency_codes: vector<vector<u8>>,
    }

    // An operations capability to allow updating of the on-chain config
    resource struct RegistrationCapability {
        cap: LibraConfig::ModifyConfigCapability<Self::T>,
    }

    public fun initialize(config_account: &signer): RegistrationCapability {
        // enforce that this is only going to one specific address,
        Transaction::assert(
            Signer::address_of(config_account) == LibraConfig::default_config_address(),
            0
        );
        let cap = LibraConfig::publish_new_config_with_capability(config_account, empty());

        RegistrationCapability { cap }
    }

    fun empty(): T {
        T { currency_codes: Vector::empty() }
    }

    public fun add_currency_code(
        currency_code: vector<u8>,
        cap: &RegistrationCapability,
    ) {
        let config = LibraConfig::get<T>();
        Vector::push_back(&mut config.currency_codes, currency_code);
        LibraConfig::set_with_capability(&cap.cap, config);
    }

}

}
