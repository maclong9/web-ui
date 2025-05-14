# WebUI API Reference

A comprehensive reference of the WebUI library's key types, protocols, and functions.

## Overview

The WebUI API provides a complete toolkit for building static websites with Swift. This reference organizes the API into logical groups to help you find exactly what you need.

## Core Components

The fundamental building blocks for creating websites.

### Document and Website

- ``Document``
- ``Website``
- ``Metadata``
- ``Theme``
- ``Script``
- ``ScriptAttribute``

### HTML Building

- ``HTML``
- ``HTMLBuilder``
- ``Children``

## Elements

Elements are the building blocks of your web pages, each representing an HTML element with specific semantics.

### Base Elements

The foundational elements for building web content.

- ``Element``
- ``Fragment``
- ``Text``
- ``Heading``
- ``List``
- ``Item``
- ``Link``
- ``Strong``
- ``Emphasis``
- ``Time``
- ``Code``
- ``Preformatted``
- ``Button``

### Media Elements

Elements for displaying images, videos, and other media.

- ``Image``
- ``Picture``
- ``Figure``
- ``Video``
- ``Audio``
- ``Source``
- ``MediaSize``

### Layout Elements

Elements for structuring page layout.

- ``Header``
- ``Main``
- ``Footer``
- ``Navigation``
- ``Section``
- ``Article``
- ``Aside``
- ``Stack``

### Form Elements

Elements for building interactive forms.

- ``Form``
- ``Input``
- ``Label``
- ``TextArea``
- ``Progress``

## Styling

Components for styling your HTML elements.

### Appearance

- ``Color``
- ``BorderStyle``
- ``RadiusSide``
- ``RadiusSize``
- ``BorderStyle``
- ``ShadowSize``

### Layout

- ``Edge``
- ``Axis``
- ``Justify``
- ``Align``
- ``Direction``
- ``Grow``
- ``OverflowType``
- ``PositionType``

### Typography

- ``TextSize``
- ``Alignment``
- ``Weight``
- ``Tracking``
- ``Leading``
- ``Decoration``
- ``Wrapping``

### Interactivity

- ``Modifier``
- ``CursorType``
- ``TransitionProperty``
- ``Easing``

## Utilities

Helper types and extensions.

### Core Utilities

- ``LoggingSetup``
- ``MarkdownParser``

### String Extensions

- ``Swift/String/render()``
- ``Swift/String/sanitizedForCSS()``
- ``Swift/String/pathFormatted()``

### Date Extensions

- ``Foundation/Date/formattedYear()``
