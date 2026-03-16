//
//  CardMocks.swift
//  hede
//
//  Created by Kevin Kelly on 6/18/25.
//

import Foundation
import Models

/*
extension PreviewMocks {
    static let basic_template: [CardElement] = [
        .init(label: "Term", media: .text(.null))
        , .init(label: "Definition", media: .text(.null))
    ]
    
    static let language_deck: FlashcardDeck = .create(
        label: "Languages"
        , parent: nil
        , description: nil
        , tags: []
        , template: basic_template
    )
        
    static let book_deck: FlashcardDeck = .create(
        label: "Books"
        , parent: nil
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let math_deck: FlashcardDeck = .create(
        label: "Math"
        , parent: nil
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let computer_science_deck: FlashcardDeck = .create(
        label: "Computer Science"
        , parent: math_deck
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let leetcode_deck: FlashcardDeck = .create(
        label: "Leetcode"
        , parent: math_deck
        , description: "Arguably not very useful outside of leetcode."
        , tags: []
        , template: basic_template
    )
    
    static let asl_deck: FlashcardDeck = .create(
        label: "ASL"
        , parent: language_deck
        , description: "American Sign Language"
        , tags: []
        , template: nil
    )
        
    static let japanese_deck: FlashcardDeck = .create(
        label: "日本語"
        , parent: language_deck
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let french_deck: FlashcardDeck = .create(
        label: "Français"
        , parent: language_deck
        , description: nil
        , tags: []
        , template: basic_template
    )
 
    
    static let secrects_of_consulting_deck: FlashcardDeck = .create(
        label: "Secrects of Consulting"
        , parent: book_deck
        , description: "Gerald M Weinberg - 1985"
        , tags: []
        , template: basic_template
    )
        
    static let sources_of_power_deck: FlashcardDeck = .create(
        label: "Sources of Power"
        , parent: book_deck
        , description: "Gary Klein - 1998"
        , tags: []
        , template: basic_template
    )
        
    static let thinking_in_systems_deck: FlashcardDeck = .create(
        label: "Thinking in Systems"
        , parent: book_deck
        , description: "Donella Meadows - 2008"
        , tags: []
        , template: basic_template
    )
    
    static let thinking_fast_and_slow_deck: FlashcardDeck = .create(
        label: "Thinking Fast and Slow"
        , parent: book_deck
        , description: "Daniel Kahneman - 2011"
        , tags: []
        , template: basic_template
    )
    
    
    static let card_initializers: [(Flashcard, FlashcardReview)] = [
        Flashcard.create(
            label: "Journal"
            , deck: japanese_deck
            , front: [.init(label: "Term", media: .text("日記"))]
            , back: [.init(label: "Definition", media: .text("Journal"))]
        )
        
        , Flashcard.create(
            label: "Pitch Black"
            , deck: japanese_deck
            , front: [.init(label: "Term", media: .text("真っ黒"))]
            , back: [.init(label: "Definition", media: .text("Pitch Black"))]
        )
        
        , Flashcard.create(
            label: "Public Behavior"
            , deck: japanese_deck
            , front: [.init(label: "Term", media: .text("建前"))]
            , back: [
                .init(label: "Definition", media: .text("Public Behavior; how you act in front of others"))
                , .init(label: "Explanation", media: .text(
                    "When you are 'in front of a building,' you are likely in public"
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Misunderstanding"
            , deck: french_deck
            , front: [.init(label: "Term", media: .text("Malentendu"))]
            , back: [.init(label: "Definition", media: .text("Misunderstanding"))]
        )
        
        , Flashcard.create(
            label: "Key"
            , deck: french_deck
            , front: [.init(label: "Term", media: .text("Clé"))]
            , back: [.init(label: "Definition", media: .text("Key"))]
        )
        
        , Flashcard.create(
            label: "Think"
            , deck: french_deck
            , front: [.init(label: "Term", media: .text("penser"))]
            , back: [.init(label: "Definition", media: .text("To think"))]
        )
        
        , Flashcard.create(
            label: "Fast-Food Fallacy"
            , deck: secrects_of_consulting_deck
            , front: [.init(label: "Term", media: .text("The Fast-Food Fallacy"))]
            , back: [.init(label: "Definition", media: .text(
                "No difference plus no difference plus no difference plus... eventually equals a clear difference."
            ))]
        )
        
        , Flashcard.create(
            label: "The Buffalo Bridle"
            , deck: secrects_of_consulting_deck
            , front: [.init(label: "Term", media: .text("The Buffalo Bridle"))]
            , back: [.init(label: "Definition", media: .text(
                "You can make a buffalo go anywhere just so long as they want to go there."
            ))]
        )
        
        , Flashcard.create(
            label: "Fisher's Fundamental Theorem"
            , deck: secrects_of_consulting_deck
            , front: [.init(label: "Term", media: .text("Fisher's Fundamental Theorem"))]
            , back: [.init(label: "Definition", media: .text(
                "The better adapted you are, the less adaptable you tend to be."
            ))]
        )
        
        
        , Flashcard.create(
            label: "Bounded Rationality"
            , deck: thinking_in_systems_deck
            , front: [.init(label: "Term", media: .text("Bounded Rationality"))]
            , back: [.init(label: "Definition", media: .text(
                "The logic that leads to decisions or actions that make sense within one part of a system but are not reasonable within a broader context or when seen as part of the wider system."
            ))]
        )
        
        , Flashcard.create(
            label: "Drift to Low Performance"
            , deck: thinking_in_systems_deck
            , front: [.init(label: "Term", media: .text("System Trap: Drift to Low Performance"))]
            , back: [
                .init(label: "Trap", media: .text(
                    "Allowing performance standards to be influenced by past performance, especially if there is a negative bias in perceiving past performance, sets up a reinforcing feedback loop of eroding goials the sets a system drifting low performance."
                ))
                , .init(label: "The Way Out", media: .text(
                    "Keep performance standards absolute. Even better, let the standards gbe enhanced by the best actual performances instead of being discouraged by the worst. Set up a drift toward high performance!"
                ))
            ]
        )
        
        // MARK: - Thinking Fast and Slow
        
        , Flashcard.create(
            label: "System 1 Thinking"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("System 1 Thinking"))]
            , back: [
                .init(label: "Definition", media: .text(
                    "Quick, automatic, effortless, inituitive thinking."
                ))
                
                , .init(label: "Examples", media: .text(
                    """
                    Chess masters intuitively recognizing good moves. Rainbolt playing Geoguesser. Firefighters and naval commanders using the **recognition primed decision model** to intuit things under pressure. Chicken sexing.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "System 2 Thinking"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("System 2 Thinking"))]
            , back: [
                .init(label: "Definition", media: .text(
                    "Slow, deliberate thought. Requires attention. How most people think of themselves. Responsible for mediating and suppressing System 1."
                ))
                
                , .init(label: "Examples", media: .text(
                    """
                    Slowly solving a math problem.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Cognitive Illusions"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Cognitive Illusions"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    Similar to how visual illusions trick our brains, these trick our System 1.
                    """
                ))
//                
//                , .init(label: "Examples", media: .text(
//                    """
//                    
//                    """
//                ))
            ]
        )
        
        , Flashcard.create(
            label: "The Law of Least Effort"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("The Law of Least Effort"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    If there multiple ways to achieve a goal, people will generally gravitate towards that of least effort. System 1 requires much less effort then System 2, and is generally accurate.
                    """
                ))
//                
//                , .init(label: "Examples", media: .text(
//                    """
//                    
//                    """
//                ))
            ]
        )
        
        , Flashcard.create(
            label: "Cognitively Busy"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Cognitively Busy"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When System 2 is active solving a problem, and its limited resources are used up.
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    System 1 becomes less suppressed by the busy System 2, and people become more rude and indulge in more pleasures. People will also be more distracted, and miss obvious abnormalities like the gorilla in the basketball video.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Ego Depletion"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Ego Depletion"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When one's 'mental energy' is used up, and system 2 is less able to deploy resources to supressing system 1 and taking on cognitive tasks. 
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    System 1 becomes less suppressed by the busy System 2, and people become more rude and indulge in more pleasures. People give up on cognitive tasks quicker. Can potentially be counter-acted with glucose consumption.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Associative Coherence"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Associative Coherence"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    Neurologically related ideas, that become more readily active through associated to a cue.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    "Banana" and "Apple" and related, coherent ideas. Reading on 'primes' the other. 
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Associative Activation"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Associative Activation"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    The activation of coherent ideas. 
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    "Banana Vomit" activates coherent ideas, such as the nausea associated with vomit.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Priming Effect"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Priming Effect"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When coherent ideas are activated and are more readily available, effecting the way one thinks and acts subconsciously.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    When presented with the fill in the blank "SO_P," if someone had more recently read the word EAT, they'd be more likely to fill in the word "SOUP," while someone who read the word WASH would more likely fill in the word "SOAP."
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Ideometer Effect"
            , deck: thinking_fast_and_slow_deck
            , front: [
                .init(label: "Term", media: .text("Ideometer Effect"))
                , .init(label: "AKA", media: .text("Florida Effect"))
            ]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When coherent ideas are activated, they can effect the way someone acts subconsciously.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    When undergrads did a sentence scramble experiment, then were directed to walk down a hallway for the next experiment, the ones who were primed with words relating to the elderly (ex. Florida, wrinkly) walked slower then the students who weren't. But if the students didn't like the elderly, they walked faster. The words primed the ideas, which then subconsciously affected the way they walked.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Cognitive Ease"
            , deck: thinking_fast_and_slow_deck
            , front: [
                .init(label: "Term", media: .text("Cognitive Ease"))
            ]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    A state where System 1 is comfortable and not strained, making it more confident in its assessments. However, this is not always accurate, as the sources of ease are not always indicators of truth. 
                    """
                ))
                
                , .init(label: "Causes", media: .text(
                    """
                    Repeated experience, clear display, good mood, primed idea.
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    Feels familiar, feels true, feels good, feels effortless. Overall more trust in system 1.
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    The mere exposure effect causing people to have more positive associations with words they've seen, despite not knowing the meaning. More clear font causing people to trust the statement more. Easier to pronounce company names and stock pickers earning more trust and higher valuations. Harder to read font on cognitive illusions, causing strain, activating System 2 more and causing people to fall for the illusion less.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Mere Exposure Effect"
            , deck: thinking_fast_and_slow_deck
            , front: [
                .init(label: "Term", media: .text("Mere Exposure Effect"))
            ]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When people are merely exposed to stimulus, even subconciously, they tend to  have a more positive perception of said stimulus.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    When undergrads did a sentance scramble experienmt, then were directed to walk down a hallway for the next experiement, the ones who were primed with words relating to the elderly (ex. Florida, wrinkly) walked slower then the students who weren't. But if the students didn't like the elderly, they walked faster. The words primed the ideas, which then subconsciously affected the way they walked.
                    """
                ))
                
                , .init(label: "Evolutionary Perspective", media: .text(
                    """
                    Familiar stimulus and settings that are known to be safe (or at least haven't yet harmed) and less likely to contain harm then completely unknown ones.
                    """
                ))
            ]
        )
        
        // MARK: - Math
        , Flashcard.create(
            label: "Sum of a Range"
            , deck: math_deck
            , front: [.init(label: "Term", media: .text("Sum of a Range"))]
            , back: [.init(label: "Equation", media: .text("(n + (n+1)) / 2"))]
        )
        
        , Flashcard.create(
            label: "Fibonacci Sequence"
            , deck: math_deck
            , front: [.init(label: "Term", media: .text("Fibonacci Sequence"))]
            , back: [.init(label: "Equation", media: .text("n[i] = n[i-1] + n[i-2]"))]
        )
        
        , Flashcard.create(
            label: "Bit Manipulation Rules"
            , deck: computer_science_deck
            , front: [.init(label: "Term", media: .text("Bit Manipulation Rules"))]
            , back: [
                .init(label: "Equation 1", media: .text("n XOR n = 0"))
                , .init(label: "Equation 2", media: .text("n XOR 0 = n"))
            ]
        )
        
        , Flashcard.create(
            label: "Binary Search"
            , deck: computer_science_deck
            , front: [.init(label: "Term", media: .text("Binary Search"))]
            , back: [
                .init(label: "Method 1", media: .text("Recursive"))
                , .init(label: "Method 2", media: .text("Non-Recursive with a loop"))
            ]
        )
        
        , Flashcard.create(
            label: "Depth-First Search"
            , deck: computer_science_deck
            , front: [.init(label: "Term", media: .text("Depth First Search"))]
            , back: [
                .init(label: "Method 1", media: .text("Recursive"))
                , .init(label: "Method 2", media: .text("Non-Recursive with a Stack"))
            ]
        )
        
        , Flashcard.create(
            label: "Number of 1's in the Binary Representation of a Number"
            , deck: leetcode_deck
            , front: [.init(label: "Term", media: .text("Number of 1's in the Binary Representation of a Number"))]
            , back: [
                .init(label: "Equation 1", media: .text("n & (n-1) + 1"))
                , .init(label: "Intuition 1", media: .text("Comparing with (n-1) removes either the one `0xNNN1 -> 0xNNN0` or shifts it `0xNN10` -> `0xNN01`, leaving one less bit then actually exists."))
                , .init(label: "Equation 2", media: .text("b(n/2)  + n & 0x1"))
                , .init(label: "Intuition 2", media: .text("Assuming the solution of n/2 is known, simply add 1 if it is odd (since the odd bit is lost in the shift."))
            ]
        )
        
    ]
    
    static let decks: [FlashcardDeck] = [
        language_deck
        , book_deck
        , asl_deck
        , japanese_deck
        , french_deck
        , secrects_of_consulting_deck
        , sources_of_power_deck
        , thinking_in_systems_deck
        , thinking_fast_and_slow_deck
    ]
    static let dropCount = 8
    static let cards = card_initializers/*.dropLast(dropCount)*/.map { $0.0 }
    static let reviews = card_initializers/*.dropLast(dropCount)*/.map { $0.1 }
}
*/
extension PreviewMocks {
    static let basic_template: [CardElement] = [
        .init(label: "Term", media: .text(.null))
        , .init(label: "Definition", media: .text(.null))
    ]
    
    static let language_deck: FlashcardDeck = .create(
        label: "Languages"
        , parent: nil
        , description: nil
        , tags: []
        , template: basic_template
    )
        
    static let book_deck: FlashcardDeck = .create(
        label: "Books"
        , parent: nil
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let math_deck: FlashcardDeck = .create(
        label: "Math"
        , parent: nil
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let computer_science_deck: FlashcardDeck = .create(
        label: "Computer Science"
        , parent: math_deck
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let leetcode_deck: FlashcardDeck = .create(
        label: "Leetcode"
        , parent: math_deck
        , description: "Arguably not very useful outside of leetcode."
        , tags: []
        , template: basic_template
    )
    
    static let asl_deck: FlashcardDeck = .create(
        label: "ASL"
        , parent: language_deck
        , description: "American Sign Language"
        , tags: []
        , template: nil
    )
        
    static let japanese_deck: FlashcardDeck = .create(
        label: "日本語"
        , parent: language_deck
        , description: nil
        , tags: []
        , template: basic_template
    )
    
    static let french_deck: FlashcardDeck = .create(
        label: "Français"
        , parent: language_deck
        , description: nil
        , tags: []
        , template: basic_template
    )
 
    
    static let secrects_of_consulting_deck: FlashcardDeck = .create(
        label: "Secrects of Consulting"
        , parent: book_deck
        , description: "Gerald M Weinberg - 1985"
        , tags: []
        , template: basic_template
    )
        
    static let sources_of_power_deck: FlashcardDeck = .create(
        label: "Sources of Power"
        , parent: book_deck
        , description: "Gary Klein - 1998"
        , tags: []
        , template: basic_template
    )
        
    static let thinking_in_systems_deck: FlashcardDeck = .create(
        label: "Thinking in Systems"
        , parent: book_deck
        , description: "Donella Meadows - 2008"
        , tags: []
        , template: basic_template
    )
    
    static let thinking_fast_and_slow_deck: FlashcardDeck = .create(
        label: "Thinking Fast and Slow"
        , parent: book_deck
        , description: "Daniel Kahneman - 2011"
        , tags: []
        , template: basic_template
    )
    
    
    static let card_initializers: [(Flashcard, FlashcardReview)] = [
        Flashcard.create(
            label: "Journal"
            , deck: japanese_deck
            , front: [.init(label: "Term", media: .text("日記"))]
            , back: [.init(label: "Definition", media: .text("Journal"))]
        )
        
        , Flashcard.create(
            label: "Pitch Black"
            , deck: japanese_deck
            , front: [.init(label: "Term", media: .text("真っ黒"))]
            , back: [.init(label: "Definition", media: .text("Pitch Black"))]
        )
        
        , Flashcard.create(
            label: "Public Behavior"
            , deck: japanese_deck
            , front: [.init(label: "Term", media: .text("建前"))]
            , back: [
                .init(label: "Definition", media: .text("Public Behavior; how you act in front of others"))
                , .init(label: "Explanation", media: .text(
                    "When you are 'in front of a building,' you are likely in public"
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Misunderstanding"
            , deck: french_deck
            , front: [.init(label: "Term", media: .text("Malentendu"))]
            , back: [.init(label: "Definition", media: .text("Misunderstanding"))]
        )
        
        , Flashcard.create(
            label: "Key"
            , deck: french_deck
            , front: [.init(label: "Term", media: .text("Clé"))]
            , back: [.init(label: "Definition", media: .text("Key"))]
        )
        
        , Flashcard.create(
            label: "Think"
            , deck: french_deck
            , front: [.init(label: "Term", media: .text("penser"))]
            , back: [.init(label: "Definition", media: .text("To think"))]
        )
        
        , Flashcard.create(
            label: "Fast-Food Fallacy"
            , deck: secrects_of_consulting_deck
            , front: [.init(label: "Term", media: .text("The Fast-Food Fallacy"))]
            , back: [.init(label: "Definition", media: .text(
                "No difference plus no difference plus no difference plus... eventually equals a clear difference."
            ))]
        )
        
        , Flashcard.create(
            label: "The Buffalo Bridle"
            , deck: secrects_of_consulting_deck
            , front: [.init(label: "Term", media: .text("The Buffalo Bridle"))]
            , back: [.init(label: "Definition", media: .text(
                "You can make a buffalo go anywhere just so long as they want to go there."
            ))]
        )
        
        , Flashcard.create(
            label: "Fisher's Fundamental Theorem"
            , deck: secrects_of_consulting_deck
            , front: [.init(label: "Term", media: .text("Fisher's Fundamental Theorem"))]
            , back: [.init(label: "Definition", media: .text(
                "The better adapted you are, the less adaptable you tend to be."
            ))]
        )
        
        
        , Flashcard.create(
            label: "Bounded Rationality"
            , deck: thinking_in_systems_deck
            , front: [.init(label: "Term", media: .text("Bounded Rationality"))]
            , back: [.init(label: "Definition", media: .text(
                "The logic that leads to decisions or actions that make sense within one part of a system but are not reasonable within a broader context or when seen as part of the wider system."
            ))]
        )
        
        , Flashcard.create(
            label: "Drift to Low Performance"
            , deck: thinking_in_systems_deck
            , front: [.init(label: "Term", media: .text("System Trap: Drift to Low Performance"))]
            , back: [
                .init(label: "Trap", media: .text(
                    "Allowing performance standards to be influenced by past performance, especially if there is a negative bias in perceiving past performance, sets up a reinforcing feedback loop of eroding goials the sets a system drifting low performance."
                ))
                , .init(label: "The Way Out", media: .text(
                    "Keep performance standards absolute. Even better, let the standards gbe enhanced by the best actual performances instead of being discouraged by the worst. Set up a drift toward high performance!"
                ))
            ]
        )
        
        // MARK: - Thinking Fast and Slow
        
        , Flashcard.create(
            label: "System 1 Thinking"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("System 1 Thinking"))]
            , back: [
                .init(label: "Definition", media: .text(
                    "Quick, automatic, effortless, inituitive thinking."
                ))
                
                , .init(label: "Examples", media: .text(
                    """
                    Chess masters intuitively recognizing good moves. Rainbolt playing Geoguesser. Firefighters and naval commanders using the **recognition primed decision model** to intuit things under pressure. Chicken sexing.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "System 2 Thinking"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("System 2 Thinking"))]
            , back: [
                .init(label: "Definition", media: .text(
                    "Slow, deliberate thought. Requires attention. How most people think of themselves. Responsible for mediating and suppressing System 1."
                ))
                
                , .init(label: "Examples", media: .text(
                    """
                    Slowly solving a math problem.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Cognitive Illusions"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Cognitive Illusions"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    Similar to how visual illusions trick our brains, these trick our System 1.
                    """
                ))
//
//                , .init(label: "Examples", media: .text(
//                    """
//
//                    """
//                ))
            ]
        )
        
        , Flashcard.create(
            label: "The Law of Least Effort"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("The Law of Least Effort"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    If there multiple ways to achieve a goal, people will generally gravitate towards that of least effort. System 1 requires much less effort then System 2, and is generally accurate.
                    """
                ))
//
//                , .init(label: "Examples", media: .text(
//                    """
//
//                    """
//                ))
            ]
        )
        
        , Flashcard.create(
            label: "Cognitively Busy"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Cognitively Busy"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When System 2 is active solving a problem, and its limited resources are used up.
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    System 1 becomes less suppressed by the busy System 2, and people become more rude and indulge in more pleasures. People will also be more distracted, and miss obvious abnormalities like the gorilla in the basketball video.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Ego Depletion"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Ego Depletion"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When one's 'mental energy' is used up, and system 2 is less able to deploy resources to supressing system 1 and taking on cognitive tasks. 
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    System 1 becomes less suppressed by the busy System 2, and people become more rude and indulge in more pleasures. People give up on cognitive tasks quicker. Can potentially be counter-acted with glucose consumption.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Associative Coherence"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Associative Coherence"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    Neurologically related ideas, that become more readily active through associated to a cue.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    "Banana" and "Apple" and related, coherent ideas. Reading on 'primes' the other. 
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Associative Activation"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Associative Activation"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    The activation of coherent ideas. 
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    "Banana Vomit" activates coherent ideas, such as the nausea associated with vomit.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Priming Effect"
            , deck: thinking_fast_and_slow_deck
            , front: [.init(label: "Term", media: .text("Priming Effect"))]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When coherent ideas are activated and are more readily available, effecting the way one thinks and acts subconsciously.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    When presented with the fill in the blank "SO_P," if someone had more recently read the word EAT, they'd be more likely to fill in the word "SOUP," while someone who read the word WASH would more likely fill in the word "SOAP."
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Ideometer Effect"
            , deck: thinking_fast_and_slow_deck
            , front: [
                .init(label: "Term", media: .text("Ideometer Effect"))
                , .init(label: "AKA", media: .text("Florida Effect"))
            ]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When coherent ideas are activated, they can effect the way someone acts subconsciously.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    When undergrads did a sentence scramble experiment, then were directed to walk down a hallway for the next experiment, the ones who were primed with words relating to the elderly (ex. Florida, wrinkly) walked slower then the students who weren't. But if the students didn't like the elderly, they walked faster. The words primed the ideas, which then subconsciously affected the way they walked.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Cognitive Ease"
            , deck: thinking_fast_and_slow_deck
            , front: [
                .init(label: "Term", media: .text("Cognitive Ease"))
            ]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    A state where System 1 is comfortable and not strained, making it more confident in its assessments. However, this is not always accurate, as the sources of ease are not always indicators of truth. 
                    """
                ))
                
                , .init(label: "Causes", media: .text(
                    """
                    Repeated experience, clear display, good mood, primed idea.
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    Feels familiar, feels true, feels good, feels effortless. Overall more trust in system 1.
                    """
                ))
                
                , .init(label: "Effects", media: .text(
                    """
                    The mere exposure effect causing people to have more positive associations with words they've seen, despite not knowing the meaning. More clear font causing people to trust the statement more. Easier to pronounce company names and stock pickers earning more trust and higher valuations. Harder to read font on cognitive illusions, causing strain, activating System 2 more and causing people to fall for the illusion less.
                    """
                ))
            ]
        )
        
        , Flashcard.create(
            label: "Mere Exposure Effect"
            , deck: thinking_fast_and_slow_deck
            , front: [
                .init(label: "Term", media: .text("Mere Exposure Effect"))
            ]
            , back: [
                .init(label: "Definition", media: .text(
                    """
                    When people are merely exposed to stimulus, even subconciously, they tend to  have a more positive perception of said stimulus.
                    """
                ))
                
                , .init(label: "Example", media: .text(
                    """
                    When undergrads did a sentance scramble experienmt, then were directed to walk down a hallway for the next experiement, the ones who were primed with words relating to the elderly (ex. Florida, wrinkly) walked slower then the students who weren't. But if the students didn't like the elderly, they walked faster. The words primed the ideas, which then subconsciously affected the way they walked.
                    """
                ))
                
                , .init(label: "Evolutionary Perspective", media: .text(
                    """
                    Familiar stimulus and settings that are known to be safe (or at least haven't yet harmed) and less likely to contain harm then completely unknown ones.
                    """
                ))
            ]
        )
        
        // MARK: - Math
        , Flashcard.create(
            label: "Sum of a Range"
            , deck: math_deck
            , front: [.init(label: "Term", media: .text("Sum of a Range"))]
            , back: [.init(label: "Equation", media: .text("(n + (n+1)) / 2"))]
        )
        
        , Flashcard.create(
            label: "Fibonacci Sequence"
            , deck: math_deck
            , front: [.init(label: "Term", media: .text("Fibonacci Sequence"))]
            , back: [.init(label: "Equation", media: .text("n[i] = n[i-1] + n[i-2]"))]
        )
        
        , Flashcard.create(
            label: "Bit Manipulation Rules"
            , deck: computer_science_deck
            , front: [.init(label: "Term", media: .text("Bit Manipulation Rules"))]
            , back: [
                .init(label: "Equation 1", media: .text("n XOR n = 0"))
                , .init(label: "Equation 2", media: .text("n XOR 0 = n"))
            ]
        )
        
        , Flashcard.create(
            label: "Binary Search"
            , deck: computer_science_deck
            , front: [.init(label: "Term", media: .text("Binary Search"))]
            , back: [
                .init(label: "Method 1", media: .text("Recursive"))
                , .init(label: "Method 2", media: .text("Non-Recursive with a loop"))
            ]
        )
        
        , Flashcard.create(
            label: "Depth-First Search"
            , deck: computer_science_deck
            , front: [.init(label: "Term", media: .text("Depth First Search"))]
            , back: [
                .init(label: "Method 1", media: .text("Recursive"))
                , .init(label: "Method 2", media: .text("Non-Recursive with a Stack"))
            ]
        )
        
        , Flashcard.create(
            label: "Number of 1's in the Binary Representation of a Number"
            , deck: leetcode_deck
            , front: [.init(label: "Term", media: .text("Number of 1's in the Binary Representation of a Number"))]
            , back: [
                .init(label: "Equation 1", media: .text("n & (n-1) + 1"))
                , .init(label: "Intuition 1", media: .text("Comparing with (n-1) removes either the one `0xNNN1 -> 0xNNN0` or shifts it `0xNN10` -> `0xNN01`, leaving one less bit then actually exists."))
                , .init(label: "Equation 2", media: .text("b(n/2)  + n & 0x1"))
                , .init(label: "Intuition 2", media: .text("Assuming the solution of n/2 is known, simply add 1 if it is odd (since the odd bit is lost in the shift."))
            ]
        )
        
    ]
    
    static let decks: [FlashcardDeck] = [
        language_deck
        , book_deck
        , asl_deck
        , japanese_deck
        , french_deck
        , secrects_of_consulting_deck
        , sources_of_power_deck
        , thinking_in_systems_deck
        , thinking_fast_and_slow_deck
    ]
    
    static let dropCount = 8
    static let cards = card_initializers/*.dropLast(dropCount)*/.map { $0.0 }
    static let reviews = card_initializers/*.dropLast(dropCount)*/.map { $0.1 }
}
