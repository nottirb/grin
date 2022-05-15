#![no_main]
#[macro_use]
extern crate libfuzzer_sys;
extern crate grin_core;
extern crate grin_p2p;

use grin_core::ser;
use grin_p2p::msg::Headers;

fuzz_target!(|data: &[u8]| {
	// TODO: the trait `Readable` is not implemented for `grin_p2p::msg::Headers`
	// let mut d = data.clone();
	// let _t: Result<Headers, ser::Error> = ser::deserialize(&mut d, ser::ProtocolVersion(1), ser::DeserializationMode::default());
});
