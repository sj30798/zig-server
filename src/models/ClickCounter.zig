pub const ClickCounter = struct {
    var counter: u32 = 0;

    pub fn IncrementCounter() void {
        ClickCounter.counter += 1;
    }

    pub fn DecrementCounter() void {
        ClickCounter.counter -= 1;
    }

    pub fn ResetCounter() void {
        ClickCounter.counter = 0;
    }

    pub fn GetCounter() u32 {
        return ClickCounter.counter;
    }
};
