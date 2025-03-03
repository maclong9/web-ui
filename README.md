# WebUI

## Notes

### Fluid Typography

```css
:root {
  --minFontSize: 16px;
  --maxFontSize: 24px;
  --minWidth: 320px;
  --maxWidth: 1200px;
  --a: calc(
    100 * (var(--maxFontSize) - var(--minFontSize)) /
      (var(--maxWidth) - var(--minWidth))
  );
  --b: calc(var(--minFontSize) - var(--a) * (var(--minWidth) / 100));
  --multiplier: 1;
  --overallMin: 12px;
  --overallMax: 36px;
}

html {
  font-size: clamp( var(--overallMin),
    calc(
      clamp(
          var(--minFontSize),
          calc(var(--a) * 1vw + var(--b)),
          var(--maxFontSize)
        ) *
        var(--multiplier)
    ),
    var(--overallMax)
  );
}

.text-xs {
  font-size: 0.75rem;
}

.text-sm {
  font-size: 0.875rem;
}

.text-base {
  font-size: 1rem;
}

.text-l {
  font-size: 1.125rem;
}

.text-xl {
  font-size: 1.25rem;
}

.text-2xl {
  font-size: 1.5rem;
}

.text-3xl {
  font-size: 1.875rem;
}

.text-4xl {
  font-size: 2.25rem;
}

.text-5xl {
  font-size: 3rem;
}

.text-6xl {
  font-size: 3.75rem;
}

.text-7xl {
  font-size: 4.5rem;
}

.text-8xl {
  font-size: 6rem;
}

.text-9xl {
  font-size: 8rem;
}

```

## Tutorials

- [Static Site Generation with WebUI](./)
- [Using WebUI with Hummingbird](./)
- [Scaling a Hummingbird Application with Cloudflare](./)

## Inspirations & Sources

- [Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10253/)
- [Hacking with Swift](https://www.hackingwithswift.com/articles/266/build-your-next-website-in-swift)
- [Elementary](https://github.com/sliemeobn/elementary/tree/main)
- [Tailwind](http://tailwindcss.com)
