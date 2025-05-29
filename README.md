<h2 align="center">
  <a href="https://github.com/dec0dOS/amazing-github-template">
    <img src="https://github.com/user-attachments/assets/657945a9-5540-4abb-a107-4f6547e4a77e" alt="Logo" width="300">
  </a>
</h2>

<div align="center">
  A library for generating websites in a simple, type-safe, and consistent manner.
  <br />
  <br />
  <a href="https://github.com/maclong9/web-ui/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>·
  <a href="https://github.com/maclong9/web-ui/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>·
  <a href="https://github.com/maclong9/web-ui/discussions">Ask a Question</a>
  <a href="https://maclong9.github.io/web-ui">Documentation</a>
</div>

<div align="center">
<br />

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmaclong9%2Fweb-ui%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/maclong9/web-ui)
[![license](https://img.shields.io/github/license/maclong9/web-ui.svg)](LICENSE)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg)](https://github.com/maclong9/web-ui/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
[![Run Tests](https://github.com/maclong9/web-ui/actions/workflows/test.yml/badge.svg)](https://github.com/maclong9/web-ui/actions/workflows/test.yml)

</div>

<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Usage](#usage)
- [Contributing](#contributing)
- [Funding](#funding)
- [Support](#support)
- [License](#license)
- [Acknowledgements](#acknowledgements)

</details>

## About

WebUI is a library for generating Web User Interfaces in a simple, type-safe,
and consistent manner. It is inspired by modern web development practices and
aims to provide a seamless experience for developers building static sites or
dynamic web applications.

### Built With

- [Swift](https://swift.org)
- [Tailwind CSS](https://tailwindcss.com)
- [Apple Swift Logging](https://github.com/apple/swift-log)
- [Swift Markdown](https://github.com/apple/swift-markdown)

## Getting Started

### Prerequisites

To use WebUI, ensure you have the following installed:

- Swift 6.1 or later

## Usage

### Script

```sh
curl -fsSL https://raw.githubusercontent.com/maclong9/web-ui/main/initialize.swift |
  swift - [--template|-t static|server] your-project-name
```

> [!NOTE]
> If you pass no template the static one will be used by default.

### Manually

Add the following to your package dependencies:
``` Package.swift
dependencies: [
    .package(url: "https://github.com/maclong9/web-ui.git", from: "1.0.0")
  ],
```

And then add this to your Target:
``` Package.swift
 .executableTarget(
      name: "Application",
      dependencies: [
        .product(name: "WebUI", package: "web-ui")
      ],
      path: "Sources",
      resources: [.process("Public")]
    )
```

### Static Site Building

The recommended approach is the GitHub action within the `.github/workflows` directory, this will build the site and push the changes to a `static` branch, you can then use this branch with most deployment providers such as Cloudflare Pages and Netlify. Below are two examples, one that uses the default options and one with some customisations for working within a monorepo, both of these examples are used in production here: [portfolio](https://github.com/maclong9/portfolio) and [comp-sci](https://github.com/maclong9/comp-sci).

**With Defaults**
``` .github/workflows/build.yml
name: Build Static Site

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: write

jobs:
  build:
    uses: maclong9/web-ui/.github/workflows/build.yml@main
```

**With Custom Options**
``` .github/workflows/build.yml
name: Build Static Site
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: write

jobs:
  build:
    uses: maclong9/web-ui/.github/workflows/build.yml@main
    with:
      working-directory: 'Application'
      generate-command: 'swift run Application'
```

## Contributing

Contributions are what make the open-source community such an amazing place to
learn, inspire, and create. Any contributions you make will benefit everybody
else and are greatly appreciated.

Please see our [CONTRIBUTING.md](CONTRIBUTING.md) document for detailed
guidelines on how to contribute to this project. All contributors are expected
to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md).

## Funding

WebUI is an independent open-source project that relies on community support. If
you find it useful, please consider supporting its development:

- [GitHub Sponsors](https://github.com/sponsors/maclong9) - Direct support for maintainers

Your support helps ensure WebUI remains actively maintained and continuously
improved. Organizations using WebUI in production are especially encouraged to
contribute financially to ensure the project's long-term sustainability.

## Support

Reach out to the maintainer at one of the following places:

- [GitHub discussions](https://github.com/maclong9/web-ui/discussions)
- The email located in the [GitHub profile](https://github.com/maclong9)

## License

This project is licensed under the **Apache 2.0 license**. See
[LICENSE](LICENSE) for more information.

## Acknowledgements

Thanks to the following resources that inspired WebUI:

- [Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10253/)
- [Hacking with Swift](https://www.hackingwithswift.com/articles/266/build-your-next-website-in-swift)
- [Elementary](https://github.com/sliemeobn/elementary/tree/main)
- [Tailwind](http://tailwindcss.com)
