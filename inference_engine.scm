;;;; inference_engine.scm

(define all-knowledge)

(define all-rules)

(define (ie:init)
  (set! all-knowledge '())
  (set! all-rules '()))


(define (ie:add-knowledge new-knowledge)
  (let ((filtered-new-knowledge
         (filter (lambda (x) (not (member x all-knowledge))) new-knowledge)))
    (set! all-knowledge (append all-knowledge filtered-new-knowledge))))

(define (ie:add-aliases new-aliases)
  (append new-aliases compound_obj_aliases))

(define (ie:add-rules new-rules)
  (append new-rules rules))

(define (ie:print-knowledge)
  (pp all-knowledge))



;; Tests
(load "./simple_data/knowledge.scm")
(pp knowledge)

(ie:init)
;Value: ()

(ie:print-knowledge)
; ()

(define excess-knowledge (list
(list 'CAUSE (list "shooting guards" 'score)
      (list
       (cons "title" "title1")
       (cons "author" "author1")
       (cons "year" "year1")
       (cons "university" "univ1")
       (cons "topic" "topic1")
       (cons "journal" "journal1")
       (cons "pubmed" "pubmed1")
       (cons "locations" (list "loc_a1" "loc_b1"))))))
;Value: excess-knowledge

(ie:add-knowledge excess-knowledge)
;Value: ()

(ie:print-knowledge)
;; ((cause
;;   ("shooting guards" score)
;;   (("title" . "title1")
;;    ("author" . "author1")
;;    ("year" . "year1")
;;    ("university" . "univ1")
;;    ("topic" . "topic1")
;;    ("journal" . "journal1")
;;    ("pubmed" . "pubmed1")
;;    ("locations" "loc_a1" "loc_b1"))))

(ie:add-knowledge excess-knowledge)
;; ;Value: ((cause ("shooting guards" score)
;; (("title" . "title1") ("author" . "author1") ("year" . "year1")
;;  ("university" . "univ1") ("topic" . "topic1") ("journal" . "journal1")
;;  ("pubmed" . "pubmed1") ("locations" "loc_a1" "loc_b1"))))

(ie:print-knowledge)
;; ((cause
;;   ("shooting guards" score)
;;   (("title" . "title1")
;;    ("author" . "author1")
;;    ("year" . "year1")
;;    ("university" . "univ1")
;;    ("topic" . "topic1")
;;    ("journal" . "journal1")
;;    ("pubmed" . "pubmed1")
;;    ("locations" "loc_a1" "loc_b1"))))









(ie:add-knowledge excess-knowledge)
