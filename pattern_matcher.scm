;;;; pattern_matcher.scm
#|
Given a set of knowledge and a set of rules, the pattern matcher
tries to apply the rules to the existing knowledge. Whenever it
finds a new statement that could be added to the knowledge based on a
rule, it calls a callback. Usually, the inference engine runs the pattern matcher and supplies
a callback that adds the new rule to the existing set of knowledge.
This is how inferences are made.

Rules usually have multiple patterns in them. pm:match-multiple
matches all the patterns in a rule while maintaining the same variable
bindings across patterns. It repeatedly calls GJS's match:combinators
to match each of the patterns.

Interface:
- (pm:match knowledge rules on_match_handler aliases)
|#

(load "load")

; load modified version of GJS matcher
(load "ghelper")
(load "matcher")

; Pseudocode in pattern_matcher_pseudocode.txt

; Given a pattern and a dictionary of variable bindings,
; returns a copy of the pattern with the values of
; the variables substituted in.
(define (pm:sub-dict-into-pattern dict pattern)  
  (define (tree-copy-with-sub tree)
    (let loop ((tree tree))
      (if (pair? tree)
        (if (equal? (car tree) '?)
          (cadr (assoc (cadr tree) dict))
          (cons (loop (car tree)) (loop (cdr tree))))
        tree)))
  
  (tree-copy-with-sub pattern))

; patterns is a list of patterns like: 
;   '((CAUSE (? a) (? b)) (CAUSE (? b) (? c)))
; pm:match-multiple tries to match each pattern in the list with
; a separate statement in knowledge. The variables are the same across
; the patterns, e.g. the '(? b)' in the statement that matches the first
; pattern must be the same as the '(? b)' in the statement that matches
; the remaining patterns. If it finds matches for all the patterns,
; it returns the result of executing cont, the success continuation.
; cont is a procedure that takes the dictionary of variable bindings
; and a list of matched_statements. Returning #f will cause all possible
; combinations of statement matches to be found by backtracking.
(define (pm:match-multiple knowledge patterns dict matched_statements cont)
  (if (equal? (length patterns) 0)
    (begin 'true-block
      (cont dict matched_statements))

    (begin 'false-block
      (call/cc (lambda (return)
        (for-each2 knowledge (lambda (statement)
          (define (cont-match-combinators newdict n)
            ;(pp `(individual-succeed ,newdict))
            (pm:match-multiple knowledge (cdr patterns) newdict (append matched_statements statement) cont))
          
          ;(pp (list "matching pattern:" (car patterns) "against:" (list (cons (car statement) (cadr statement)))  ))
          
          (let* ((clause_and_args (list (cons (car statement) (cadr statement))))
                 (x ((match:->combinators (car patterns)) clause_and_args dict cont-match-combinators)))
            (if x (return x)))))
        (return #f))))))

; Each rule in the rules list is a rule that contains:
;   (1) matching patterns - these must be matched by existing statements
;   (2) a "rewrite rule" used to generate a new knowledge statement
; pm:match will match the set of knowledge against each rule
; using pm:match multiple. Whenever it finds a match, it calls
; the on_match_handler supplied by the user.
; on_match_handler is a procedure of 3 arguments:
;   (1) knowledge - a reference to the existing set of knowledge)
;   (2) matched_statements - the statements that matched the matching
;       patterns of the rule
;   (3) new_statement - the statement generated by the rewrite rule
; The inference engine, which calls pm:match, is supposed to supply
; an on_match_handler that adds the new statement to the existing
; set of knowledge.
; pm:match will continue to run the size of the existing knowledge
; stops growing (meaning all possible matches were found).
(define (pm:match knowledge rules on_match_handler aliases)
  (let ((old_knowledge_size (length knowledge)))
    (match:set-compound_obj_aliases! aliases)
    
    (for-each2 rules (lambda(rule)
      (let ((patterns (car rule))
            (new_statement_pattern (cdr rule)))
      
        (define (cont-match-multiple newdict matched_statements)
          (let ((new_statement (pm:sub-dict-into-pattern newdict new_statement_pattern)))
            (on_match_handler knowledge matched_statements new_statement)
            #f))
        
        (pm:match-multiple knowledge patterns '() '() cont-match-multiple))))
  
    ; if knowledge changed, repeat pm:match
    (if (> (length knowledge) old_knowledge_size)
      (pm:match knowledge rules on_match_handler aliases))))
