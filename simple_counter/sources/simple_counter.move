module simple_counter::simple_counter {
    
    use sui::event;

    
    const ECounterNotMutable: u64 = 0;

    /// A counter that can only be incremented
    public struct Counter has key, store {
        id: object::UID,
        value: u64,
        owner: address
    }

    public struct CounterCreated has copy, drop {
        counter_id: address,
        initial_value: u64,
        creator: address
    }


    public struct CounterIncremented has copy, drop {
        counter_id: address,
        old_value: u64,
        new_value: u64
    }

    public fun create(ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let id = object::new(ctx);
        let counter_id = object::uid_to_address(&id);
        

        let counter = Counter {
            id,
            value: 0,
            owner: sender
        };
        
        // Emit creation event
        event::emit(CounterCreated {
            counter_id,
            initial_value: 0,
            creator: sender
        });
        
        // Share the counter object - making it accessible to everyone
        transfer::share_object(counter);
    }
    public fun create_with_value(initial_value: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let id = object::new(ctx);
        let counter_id = object::uid_to_address(&id);
        
        
        let counter = Counter {
            id,
            value: initial_value,
            owner: sender
        };
        
       
        event::emit(CounterCreated {
            counter_id,
            initial_value,
            creator: sender
        });
        
        // Share the counter object
        transfer::share_object(counter);
    }

    /// Increment the counter by 1
    public entry fun increment(counter: &mut Counter) {
        let old_value = counter.value;
        counter.value = counter.value + 1;
        
        // Emit increment event
        event::emit(CounterIncremented {
            counter_id: object::uid_to_address(&counter.id),
            old_value,
            new_value: counter.value
        });
    }

        public entry fun reset(counter: &mut Counter, ctx: &TxContext) {
        assert!(counter.owner == tx_context::sender(ctx), ECounterNotMutable);
        let old_value = counter.value;
        counter.value = 0;
        
       
        event::emit(CounterIncremented {
            counter_id: object::uid_to_address(&counter.id),
            old_value,
            new_value: 0
        });
    }

    /// Read the counter's current value
    public fun value(counter: &Counter): u64 {
        counter.value
    }

    public fun is_owner(counter: &Counter, addr: address): bool {
        counter.owner == addr
    }
}