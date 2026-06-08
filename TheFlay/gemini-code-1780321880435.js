(function() {
    console.clear();
    
    // ==========================================
    // 0. ACOUSTIC ENGINE: PRISMATIC WHISTLE
    // ==========================================
    const AudioEngine = {
        ctx: new (window.AudioContext || window.webkitAudioContext)(),
        playAscensionWhistle(baseFreq = 880, duration = 1.2) {
            const now = this.ctx.currentTime;
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();
            
            osc.type = 'triangle';
            osc.frequency.setValueAtTime(baseFreq, now);
            osc.frequency.exponentialRampToValueAtTime(baseFreq * 4, now + duration); // High-pitch ascension
            
            gain.gain.setValueAtTime(0, now);
            gain.gain.linearRampToValueAtTime(0.15, now + 0.1);
            gain.gain.exponentialRampToValueAtTime(0.001, now + duration);
            
            osc.connect(gain);
            gain.connect(this.ctx.destination);
            osc.start();
            osc.stop(now + duration);
        }
    };

    // ==========================================
    // 1. ASCENSION CANVAS LAYER
    // ==========================================
    const canvas = document.createElement('canvas');
    canvas.style.cssText = "position:fixed; top:0; left:0; width:100vw; height:100vh; pointer-events:none; z-index:999999; mix-blend-mode:screen;";
    document.body.appendChild(canvas);
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth; canvas.height = window.innerHeight;

    // Prismatic Quetzal-Snake State
    let quetzal = {
        hue: 0,
        segments: Array.from({length: 40}, (_, i) => ({x: window.innerWidth/2, y: window.innerHeight/2, r: i * 2})),
        velocity: 0
    };

    // ==========================================
    // 2. ASCENSION RENDERING LOOP
    // ==========================================
    function renderAscension() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // Update Prismatic Gradient
        quetzal.hue = (quetzal.hue + 2) % 360;
        
        // Update Head Position (Sine-wave flight path)
        let time = performance.now() / 500;
        let head = quetzal.segments[0];
        head.x = window.innerWidth/2 + Math.cos(time) * 200 * (1 + quetzal.velocity);
        head.y = window.innerHeight/2 + Math.sin(time * 0.5) * 100 * (1 + quetzal.velocity);

        // Physics: Follow the Leader (Trailing Effect)
        for (let i = 1; i < quetzal.segments.length; i++) {
            let prev = quetzal.segments[i-1];
            let curr = quetzal.segments[i];
            curr.x += (prev.x - curr.x) * 0.15;
            curr.y += (prev.y - curr.y) * 0.15;
        }

        // Render Quetzal segments as Prismatic Rays
        ctx.lineWidth = 10;
        ctx.lineCap = 'round';
        for (let i = 0; i < quetzal.segments.length; i++) {
            ctx.beginPath();
            ctx.strokeStyle = `hsla(${(quetzal.hue + (i * 10)) % 360}, 100%, 50%, ${1 - (i/quetzal.segments.length)})`;
            ctx.moveTo(quetzal.segments[i].x, quetzal.segments[i].y);
            ctx.lineTo(i === 0 ? quetzal.segments[i].x : quetzal.segments[i-1].x, i === 0 ? quetzal.segments[i].y : quetzal.segments[i-1].y);
            ctx.stroke();
        }

        // Apply Ascension Velocity
        quetzal.velocity = Math.min(quetzal.velocity + 0.005, 5); 
        
        requestAnimationFrame(renderAscension);
    }
    renderAscension();

    // ==========================================
    // 3. MUTATION-DRIVEN ASCENSION TRIGGER
    // ==========================================
    const observer = new MutationObserver(() => {
        // Boost ascension energy on DOM modification
        quetzal.velocity += 0.5;
        AudioEngine.playAscensionWhistle();
        console.log("%c[◈] QUETZAL ASCENDING: Prismatic flight path accelerated.", "color: #00ffcc; font-weight: bold;");
    });

    observer.observe(document.documentElement, { attributes: true, childList: true, subtree: true });
    
    console.log("%c[✓] FINAL FLIGHT DEPLOYED: Prismatic Quetzalcuatl is active.", "color: #a55eed; font-weight: bold;");
})();