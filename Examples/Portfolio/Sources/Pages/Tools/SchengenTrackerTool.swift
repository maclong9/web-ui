import Foundation
import WebUI

/// Schengen Tracker tool page
struct SchengenTrackerTool: Document {
    var metadata: Metadata {
        Metadata(
            site: "Mac Long Tools",
            title: "Schengen Tracker", 
            description: "Track your visits to Schengen Area countries with automatic day calculations"
        )
    }
    
    var path: String? { "tools/schengen-tracker" }
    
    var body: some Markup {
        BaseDocument(
            metadata: metadata,
            breadcrumbs: [
                .init(title: "Tools", url: "/tools"),
                .init(title: "Schengen Tracker", url: "/tools/schengen-tracker")
            ],
            emoji: "✈️",
            alpineComponent: "schengenTrackerApp()"
        ) {
            Stack {
                // Tool header
                Section {
                    Stack {
                        Heading(.largeTitle, "✈️ Schengen Tracker", classes: ["text-3xl", "font-bold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Text("Track your visits to Schengen Area countries with automatic day calculations", classes: ["text-lg", "text-zinc-600", "dark:text-zinc-400"])
                    }
                }
                
                // Current status
                Section {
                    Stack {
                        Heading(.title, "Current Status", classes: ["text-xl", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Stack {
                            Stack {
                                Text("", classes: ["text-2xl", "font-bold", "text-teal-600", "dark:text-teal-400"])
                                Text("Days Used", classes: ["text-sm", "text-teal-700", "dark:text-teal-300"])
                            }
                            
                            Stack {
                                Text("", classes: ["text-2xl", "font-bold", "text-blue-600", "dark:text-blue-400"])
                                Text("Days Remaining", classes: ["text-sm", "text-blue-700", "dark:text-blue-300"])
                            }
                            
                            Stack {
                                Text("", classes: ["text-2xl", "font-bold", "text-amber-600", "dark:text-amber-400"])
                                Text("Next Reset", classes: ["text-sm", "text-amber-700", "dark:text-amber-300"])
                            }
                        }
                    }
                }
                
                // Add visit form
                Section {
                    Stack {
                        Heading(.title, "Add Visit", classes: ["text-xl", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Form {
                            Stack {
                                Stack {
                                    Label(for: "country", classes: ["block", "text-sm", "font-medium", "text-zinc-700", "dark:text-zinc-300"]) {
                                        "Country"
                                    }
                                    
                                    Select(id: "country", classes: ["w-full", "px-3", "py-2", "border", "border-zinc-300", "dark:border-zinc-600", "rounded-lg", "bg-white", "dark:bg-zinc-700", "text-zinc-900", "dark:text-zinc-100"]) {
                                        Option("Select Country", value: "")
                                        Option("France", value: "FR")
                                        Option("Germany", value: "DE")
                                        Option("Italy", value: "IT")
                                        Option("Spain", value: "ES")
                                        Option("Netherlands", value: "NL")
                                    }
                                }
                                
                                Stack {
                                    Label(for: "entryDate", classes: ["block", "text-sm", "font-medium", "text-zinc-700", "dark:text-zinc-300"]) {
                                        "Entry Date"
                                    }
                                    
                                    Input(.date, id: "entryDate", classes: ["w-full", "px-3", "py-2", "border", "border-zinc-300", "dark:border-zinc-600", "rounded-lg", "bg-white", "dark:bg-zinc-700", "text-zinc-900", "dark:text-zinc-100"])
                                }
                            }
                            
                            Stack {
                                Stack {
                                    Label(for: "exitDate", classes: ["block", "text-sm", "font-medium", "text-zinc-700", "dark:text-zinc-300"]) {
                                        "Exit Date"
                                    }
                                    
                                    Input(.date, id: "exitDate", classes: ["w-full", "px-3", "py-2", "border", "border-zinc-300", "dark:border-zinc-600", "rounded-lg", "bg-white", "dark:bg-zinc-700", "text-zinc-900", "dark:text-zinc-100"])
                                }
                                
                                Stack {
                                    Button("Add Visit", classes: ["px-6", "py-2", "bg-teal-600", "hover:bg-teal-700", "text-white", "font-medium", "rounded-lg", "transition-colors"]) {}
                                }
                            }
                        }
                    }
                }
                
                // Visit history
                Section {
                    Stack {
                        Heading(.title, "Visit History", classes: ["text-xl", "font-semibold", "text-zinc-900", "dark:text-zinc-100", "mb-4"])
                        
                        Stack {
                            Text("No visits recorded yet. Add your first visit above.", classes: ["text-center", "text-zinc-500", "py-8"])
                        }
                        
                        Stack {
                            Text("Visit entries will appear here...", classes: ["text-zinc-500", "text-center", "py-4"])
                        }
                    }
                }
                
                // Information
                Section {
                    Stack {
                        Heading(.headline, "About the Schengen Area", classes: ["text-lg", "font-semibold", "text-blue-900", "dark:text-blue-100", "mb-4"])
                        
                        Text("The Schengen Area allows visa-free travel for up to 90 days within any 180-day period. This tool helps you track your visits to ensure compliance with the 90/180 rule.", classes: ["text-blue-800", "dark:text-blue-200", "mb-4"])
                        
                        List(classes: ["space-y-2", "text-blue-800", "dark:text-blue-200"]) {
                            Item("90 days maximum stay within any 180-day period")
                            Item("The 180-day period is a rolling window") 
                            Item("Days are calculated from entry to exit date")
                            Item("All Schengen countries count toward the limit")
                        }
                    }
                }
            }
        }
    }
    
    var scripts: [Script]? {
        [
            Script(content: { """
                function schengenTrackerApp() {
                    return {
                        visits: [],
                        newVisit: {
                            country: '',
                            entryDate: '',
                            exitDate: ''
                        },
                        
                        get daysUsed() {
                            return this.calculateDaysUsed();
                        },
                        
                        get daysRemaining() {
                            return Math.max(0, 90 - this.daysUsed);
                        },
                        
                        get nextResetDate() {
                            return 'Jan 1';  // Simplified calculation
                        },
                        
                        calculateDaysUsed() {
                            // Simplified calculation - in real implementation would properly calculate rolling 180-day window
                            return this.visits.reduce((total, visit) => {
                                if (visit.entryDate && visit.exitDate) {
                                    const entry = new Date(visit.entryDate);
                                    const exit = new Date(visit.exitDate);
                                    const days = Math.ceil((exit - entry) / (1000 * 60 * 60 * 24)) + 1;
                                    return total + days;
                                }
                                return total;
                            }, 0);
                        },
                        
                        addVisit() {
                            if (this.newVisit.country && this.newVisit.entryDate && this.newVisit.exitDate) {
                                this.visits.push({...this.newVisit});
                                this.newVisit = { country: '', entryDate: '', exitDate: '' };
                                this.saveData();
                            }
                        },
                        
                        saveData() {
                            localStorage.setItem('schengenVisits', JSON.stringify(this.visits));
                        },
                        
                        loadData() {
                            const saved = localStorage.getItem('schengenVisits');
                            if (saved) {
                                this.visits = JSON.parse(saved);
                            }
                        },
                        
                        initApp() {
                            this.loadData();
                        }
                    }
                }
                """ })
        ]
    }
}