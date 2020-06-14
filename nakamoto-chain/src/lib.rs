#[allow(clippy::len_without_is_empty)]
#[allow(clippy::collapsible_if)]
#[deny(
    unsafe_code,
    missing_debug_implementations,
    missing_copy_implementations
)]
pub mod block;
pub mod checkpoints;
pub mod genesis;

#[cfg(test)]
mod tests;
