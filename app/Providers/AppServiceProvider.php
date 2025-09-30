<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    protected function configureRateLimiting()
{
    RateLimiter::for('api', function (Request $request) {
        return Limit::perMinute(60)->by(<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>r</mi><mi>e</mi><mi>q</mi><mi>u</mi><mi>e</mi><mi>s</mi><mi>t</mi><mo>−</mo><mo>&gt;</mo><mi>u</mi><mi>s</mi><mi>e</mi><mi>r</mi><mo stretchy="false">(</mo><mo stretchy="false">)</mo><mo stretchy="false">?</mo><mo>−</mo><mo>&gt;</mo><mi>i</mi><mi>d</mi><mo stretchy="false">?</mo><mo>:</mo></mrow><annotation encoding="application/x-tex">request-&gt;user()?-&gt;id ?: </annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8095em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">re</span><span class="mord mathnormal" style="margin-right:0.03588em;">q</span><span class="mord mathnormal">u</span><span class="mord mathnormal">es</span><span class="mord mathnormal">t</span><span class="mord">−</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">&gt;</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">u</span><span class="mord mathnormal" style="margin-right:0.02778em;">ser</span><span class="mopen">(</span><span class="mclose">)?</span><span class="mord">−</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">&gt;</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">i</span><span class="mord mathnormal">d</span><span class="mclose">?</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span></span></span></span>request->ip());
    });
}

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
