(function() {
    console.clear();

    // ==========================================
    // 0. AUDIO SYNTHESIS ENGINE (CHIME & SPEECH)
    // ==========================================
    const AudioEngine = {
        ctx: null,
        
        initContext() {
            if (!this.ctx) {
                this.ctx = new (window.AudioContext || window.webkitAudioContext)();
            }
        },

        playChime(frequency = 587.33, duration = 0.15) {
            try {
                this.initContext();
                if (!this.ctx) return;

                const osc = this.ctx.createOscillator();
                const gainNode = this.ctx.createGain();

                osc.type = 'sine';
                osc.frequency.setValueAtTime(frequency, this.ctx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(frequency * 1.5, this.ctx.currentTime + duration);

                gainNode.gain.setValueAtTime(0.15, this.ctx.currentTime);
                gainNode.gain.exponentialRampToValueAtTime(0.001, this.ctx.currentTime + duration);

                osc.connect(gainNode);
                gainNode.connect(this.ctx.destination);

                osc.start();
                osc.stop(this.ctx.currentTime + duration);
            } catch (e) {}
        },

        speak(text) {
            if ('speechSynthesis' in window) {
                const utterance = new SpeechSynthesisUtterance(text);
                utterance.rate = 1.0;
                utterance.pitch = 1.0;
                window.speechSynthesis.speak(utterance);
            }
        }
    };

    // ==========================================
    // 1. CL34RBOXX & XIPE TOTEC HEADER
    // ==========================================
    const clearBoxLogo = `
 ┌────────────────────────────────────────────────────────┐
 │   ██████╗██╗     ██████╗  ██╗  ██╗██████╗  ██████╗ ██╗  ██╗│
 │  ██╔════╝██║     ╚════██╗██║  ██║██╔══██╗██╔═══██╗╚██╗██╔╝│
 │  ██║     ██║      █████╔╝███████║██████╔╝██║   ██║ ╚███╔╝ │
 │  ██║     ██║     ██╔═══╝ ╚════██║██╔══██╗██║   ██║ ██╔██╗ │
 │  ╚██████╗███████╗███████╗     ██║██║  ██║╚██████╔╝██╔╝ ██╗│
 │   ╚═════╝╚══════╝╚══════╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝│
 ├────────────────────────────────────────────────────────┤
 │     CAJACL34R // XIPE TOTEC FLAY LAYER DEPLOYMENT      │
 └────────────────────────────────────────────────────────┘
    `;
    console.log(`%c${clearBoxLogo}`, "color: #ff3366; font-family: monospace; font-weight: bold;");
    
    AudioEngine.speak("Clear Box System Online. Xipe Totec Layer Active.");

    // ==========================================
    // 2. EXTRACT DATA & ENVIRONMENT METADATA
    // ==========================================
    const auditManifest = {
        identity: {
            domain: window.location.hostname || "Isolated Context",
            href: window.location.href,
            origin: window.location.origin,
            timestamp: new Date().toISOString()
        },
        domMetrics: {
            totalNodes: document.getElementsByTagName('*').length,
            scriptsDetected: document.scripts.length,
            iframesDetected: document.getElementsByTagName('iframe').length
        }
    };

    const obsidianMarkdown = `---
type: security-audit
target: ${auditManifest.identity.domain}
timestamp: ${auditManifest.identity.timestamp}
agent: XIPE_TOTEC_ENGINE
tags:
  - audit/runtime
  - visual/flay-layer
---
# Runtime Audit Manifest: ${auditManifest.identity.domain}
- **Collected At:** [[${auditManifest.identity.timestamp.split('T')[0]}]]
- **Total Registered Elements:** \`${auditManifest.domMetrics.totalNodes}\`
- **Active Script Footprints:** \`${auditManifest.domMetrics.scriptsDetected}\`
---`;

    console.log(`%c${obsidianMarkdown}`, "color: #ffaa00; font-family: monospace; font-size: 11px;");

    // ==========================================
    // 3. XIPE TOTEC CANVAS OVERLAY INITIALIZATION
    // ==========================================
    const canvas = document.createElement('canvas');
    canvas.id = 'xipe-totec-flay-overlay';
    Object.assign(canvas.style, {
        position: 'fixed',
        top: '0',
        left: '0',
        width: '100vw',
        height: '100vh',
        pointerEvents: 'none', 
        zIndex: '999999',
        mixBlendMode: 'screen'
    });
    document.body.appendChild(canvas);

    const ctx = canvas.getContext('2d');
    
    function resizeCanvas() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    // Track active target element flay indicators
    let activeFlayTargets = [];
    let snakes = [];
    const maxSnakes = 16;
    const palette = ['#ff3366', '#ffaa00', '#d1ff33', '#00ffcc', '#0077ff'];

    function createSnake() {
        return {
            points: Array.from({length: 20}, () => ({x: Math.random() * canvas.width, y: Math.random() * canvas.height})),
            speed: 3 + Math.random() * 4,
            color: palette[Math.floor(Math.random() * palette.length)],
            width: 1.5 + Math.random() * 1.5,
            angle: Math.random() * Math.PI * 2,
            turnSpeed: (Math.random() - 0.5) * 0.12
        };
    }

    for (let i = 0; i < maxSnakes; i++) {
        snakes.push(createSnake());
    }

    // ==========================================
    // 4. ANIMATION & RENDERING LOOP
    // ==========================================
    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // --- Render Layer A: Flayed DOM Targets ---
        activeFlayTargets.forEach((target, index) => {
            if (target.opacity <= 0) {
                activeFlayTargets.splice(index, 1);
                return;
            }

            ctx.save();
            ctx.strokeStyle = `rgba(255, 51, 102, ${target.opacity})`;
            ctx.lineWidth = 2;
            
            // Draw localized crosshairs and bounding structure over target node bounds
            ctx.strokeRect(target.rect.left, target.rect.top, target.rect.width, target.rect.height);
            
            // Xipe Totec Geometric Slices (Internal Wireframe Lines)
            ctx.beginPath();
            ctx.moveTo(target.rect.left, target.rect.top);
            ctx.lineTo(target.rect.right, target.rect.bottom);
            ctx.moveTo(target.rect.right, target.rect.top);
            ctx.lineTo(target.rect.left, target.rect.bottom);
            ctx.strokeStyle = `rgba(255, 170, 0, ${target.opacity * 0.4})`;
            ctx.stroke();

            ctx.restore();
            
            // Decay structural highlight visibility
            target.opacity -= 0.015;
        });

        // --- Render Layer B: Matrix Wires (Cloud Snakes) ---
        snakes.forEach(snake => {
            snake.angle += snake.turnSpeed;
            if (Math.random() < 0.05) {
                snake.turnSpeed = (Math.random() - 0.5) * 0.2;
            }

            let head = {
                x: snake.points[0].x + Math.cos(snake.angle) * snake.speed,
                y: snake.points[0].y + Math.sin(snake.angle) * snake.speed
            };

            if (head.x < 0) head.x = canvas.width;
            if (head.x > canvas.width) head.x = 0;
            if (head.y < 0) head.y = canvas.height;
            if (head.y > canvas.height) head.y = 0;

            snake.points.unshift(head);
            snake.points.pop();

            ctx.beginPath();
            ctx.moveTo(snake.points[0].x, snake.points[0].y);
            for (let i = 1; i < snake.points.length; i++) {
                let xc = (snake.points[i].x + snake.points[i - 1].x) / 2;
                let yc = (snake.points[i].y + snake.points[i - 1].y) / 2;
                ctx.quadraticCurveTo(snake.points[i - 1].x, snake.points[i - 1].y, xc, yc);
            }

            ctx.strokeStyle = snake.color;
            ctx.lineWidth = snake.width;
            ctx.lineCap = 'round';
            ctx.stroke();
        });

        requestAnimationFrame(animate);
    }
    requestAnimationFrame(animate);

    // ==========================================
    // 5. MUTATION INTERCEPTION INTERFACE
    // ==========================================
    let lastChimeTime = 0;
    const chimeCooldown = 100;

    const mutationObserver = new MutationObserver((mutations) => {
        let uniqueMutationsFound = false;

        mutations.forEach((mutation) => {
            uniqueMutationsFound = true;

            // Only capture elements with safe physical viewport boundaries
            if (mutation.target && typeof mutation.target.getBoundingClientRect === 'function') {
                const rect = mutation.target.getBoundingClientRect();
                
                // Add valid, visible targets to the flay visual tracker list
                if (rect.width > 0 && rect.height > 0) {
                    activeFlayTargets.push({
                        rect: rect,
                        opacity: 1.0,
                        node: mutation.target.nodeName
                    });
                }
            }

            // Scatter matrix strings to match architectural changes
            snakes.forEach(snake => {
                snake.speed = 10 + Math.random() * 5;
                snake.angle = Math.random() * Math.PI * 2;
                
                setTimeout(() => {
                    snake.speed = 3 + Math.random() * 4;
                }, 600);
            });
        });

        if (uniqueMutationsFound) {
            const now = performance.now();
            if (now - lastChimeTime > chimeCooldown) {
                console.log("%c[◈] XIPE TOTEC LAYER: Mutation flayed into viewport structure.", "color: #ff3366; font-family: monospace;");
                AudioEngine.playChime(698.46, 0.1); // High F5 chime signature
                lastChimeTime = now;
            }
        }
    });

    mutationObserver.observe(document.documentElement || document.body, {
        attributes: true,
        childList: true,
        subtree: true,
        characterData: true
    });

    console.log("%c[✓] XIPE TOTEC ACTIVATION COMPLETE: Viewport wireframe flaying monitoring active.", "color: #ff3366; font-family: monospace;");
})();