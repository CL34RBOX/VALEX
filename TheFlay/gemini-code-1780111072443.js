(() => {
    const chunkName = "webpackChunk_mozilla_sumo"; // Adapt identifier matching the host target
    let baseArray = self[chunkName] || [];

    // Intercept ongoing array updates
    Object.defineProperty(self, chunkName, {
        get: () => baseArray,
        set: (newArray) => {
            console.log(`[AUDIT] Webpack Runtime initialization intercepted.`);
            baseArray = newArray;
            
            // Inject listener onto the mutated push method
            const originalPush = baseArray.push;
            baseArray.push = function(...chunks) {
                const chunkIds = chunks[0][0];
                console.log(`[90247_HYDRATION] Dynamic script chunk injected: [ID: ${chunkIds}]`);
                return originalPush.apply(this, chunks);
            };
        },
        configurable: true
    });
})();