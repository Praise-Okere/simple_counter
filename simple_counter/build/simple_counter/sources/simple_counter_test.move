#[test_only]

module simple_counter::simple_counter_test{
    use simple_counter::simple_counter;
    use sui::test_scenario as ts;
    use sui::test_utils::assert_eq;
    
    #[test]
    fun test_create() {
        let mut scenario= ts::begin(@0xa);
        {
            simple_counter::create(scenario.ctx());
        };
        let effect=scenario.next_tx(@0xa);
        assert_eq(effect.num_user_events(), 1);
        scenario.end();
    }
}