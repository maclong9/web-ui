import Foundation
import WebUI

/// Barre Scales interactive tool page
struct BarreScalesTool: Document {
    var metadata: Metadata {
        Metadata(
            site: "Mac Long Tools",
            title: "Barre Scales",
            description: "Interactive guitar barre scales chart with multiple scales and positions"
        )
    }
    
    var path: String? { "tools/barre-scales" }
    
    var body: some Markup {
        BaseDocument(
            metadata: metadata,
            breadcrumbs: [
                .init(title: "Tools", url: "/tools"),
                .init(title: "Barre Scales", url: "/tools/barre-scales")
            ],
            emoji: "🎸",
            alpineComponent: "barreScalesApp()"
        ) {
            Stack {
                // Tool header
                Section {
                    Stack {
                        Heading(.largeTitle, "🎸 Barre Scales", classes: ["text-3xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Text("Interactive guitar barre scales chart with multiple scales and positions", classes: ["text-lg", "text-zinc-600", "dark:text-zinc-400"])
                    }
                }
                
                // Controls
                Section {
                    Stack {
                        Stack {
                            // Scale selector
                            Stack {
                                Text("Scale:", classes: ["font-medium", "text-zinc-700", "dark:text-zinc-300"])
                                
                                Select(classes: ["px-3", "py-2", "border", "border-zinc-300", "dark:border-zinc-600", "rounded-lg", "bg-white", "dark:bg-zinc-700", "text-zinc-900", "dark:text-zinc-100"]) {
                                    Option("Major", value: "major")
                                    Option("Minor", value: "minor")
                                    Option("Pentatonic Major", value: "pentatonic-major")
                                    Option("Pentatonic Minor", value: "pentatonic-minor")
                                    Option("Blues", value: "blues")
                                    Option("Dorian", value: "dorian")
                                    Option("Mixolydian", value: "mixolydian")
                                }
                            }
                            
                            // Root note selector  
                            Stack {
                                Text("Root:", classes: ["font-medium", "text-zinc-700", "dark:text-zinc-300"])
                                
                                Select(classes: ["px-3", "py-2", "border", "border-zinc-300", "dark:border-zinc-600", "rounded-lg", "bg-white", "dark:bg-zinc-700", "text-zinc-900", "dark:text-zinc-100"]) {
                                    Option("C", value: "C")
                                    Option("C#/Db", value: "Cs")
                                    Option("D", value: "D")
                                    Option("D#/Eb", value: "Ds")
                                    Option("E", value: "E")
                                    Option("F", value: "F")
                                    Option("F#/Gb", value: "Fs")
                                    Option("G", value: "G")
                                    Option("G#/Ab", value: "Gs")
                                    Option("A", value: "A")
                                    Option("A#/Bb", value: "As")
                                    Option("B", value: "B")
                                }
                            }
                            
                            // Position selector
                            Stack {
                                Text("Position:", classes: ["font-medium", "text-zinc-700", "dark:text-zinc-300"])
                                
                                Select(classes: ["px-3", "py-2", "border", "border-zinc-300", "dark:border-zinc-600", "rounded-lg", "bg-white", "dark:bg-zinc-700", "text-zinc-900", "dark:text-zinc-100"]) {
                                    Option("Position 1", value: "1")
                                    Option("Position 2", value: "2")
                                    Option("Position 3", value: "3")
                                    Option("Position 4", value: "4")
                                    Option("Position 5", value: "5")
                                }
                            }
                        }
                    }
                }
                
                // Fretboard display
                Section {
                    Stack {
                        Text("Interactive fretboard would be displayed here using JavaScript/Canvas", classes: ["text-center", "text-zinc-500", "p-8", "bg-zinc-100", "dark:bg-zinc-800", "rounded-lg", "border-2", "border-dashed", "border-zinc-300", "dark:border-zinc-600"])
                    }
                }
                
                // Instructions
                Section {
                    Stack {
                        Heading(.headline, "How to Use", classes: ["text-lg", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        List(classes: ["space-y-3", "text-zinc-600", "dark:text-zinc-400"]) {
                            Item("Select a scale type from the dropdown menu")
                            Item("Choose your desired root note")
                            Item("Pick a position on the fretboard")
                            Item("The scale pattern will be highlighted on the fretboard")
                            Item("Practice the pattern and try different positions")
                        }
                    }
                }
            }
        }
    }
    
    var scripts: [Script]? {
        [
            Script(
                content: """
                function barreScalesApp() {
                    return {
                        selectedScale: 'major',
                        selectedRoot: 'C',
                        selectedPosition: '1',
                        
                        scales: {
                            major: [2, 2, 1, 2, 2, 2, 1],
                            minor: [2, 1, 2, 2, 1, 2, 2],
                            'pentatonic-major': [2, 2, 3, 2, 3],
                            'pentatonic-minor': [3, 2, 2, 3, 2],
                            blues: [3, 2, 1, 1, 3, 2],
                            dorian: [2, 1, 2, 2, 2, 1, 2],
                            mixolydian: [2, 2, 1, 2, 2, 1, 2]
                        },
                        
                        notes: ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'],
                        
                        init() {
                            this.updateFretboard();
                        },
                        
                        updateFretboard() {
                            // This would update the fretboard visualization
                            console.log('Updating fretboard:', {
                                scale: this.selectedScale,
                                root: this.selectedRoot,
                                position: this.selectedPosition
                            });
                        },
                        
                        $watch: {
                            selectedScale() { this.updateFretboard(); },
                            selectedRoot() { this.updateFretboard(); },
                            selectedPosition() { this.updateFretboard(); }
                        }
                    }
                }
                """
            )
        ]
    }
}