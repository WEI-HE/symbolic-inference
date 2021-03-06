(define compound_obj_aliases (list
  (cons "shooting guards" (list 'kobe 'wade 'mj 'jordan))
))

(define knowledge (list
  (list 'CAUSE (list 'lakers 'kobe) (list
    (cons "title" "title0")
    (cons "author" "author0")
    (cons "year" "year0")
    (cons "university" "univ0")
    (cons "topic" "topic0")
    (cons "journal" "journal0")
    (cons "pubmed" "pubmed0")
    (cons "locations" (list "loc_a0" "loc_b0"))
    ))
  (list 'CAUSE (list "shooting guards" 'score) (list
    (cons "title" "title1")
    (cons "author" "author1")
    (cons "year" "year1")
    (cons "university" "univ1")
    (cons "topic" "topic1")
    (cons "journal" "journal1")
    (cons "pubmed" "pubmed1")
    (cons "locations" (list "loc_a1" "loc_b1"))
    ))
  (list 'CAUSE (list 'score 'point) (list
    (cons "title" "title2")
    (cons "author" "author2")
    (cons "year" "year2")
    (cons "university" "univ2")
    (cons "topic" "topic2")
    (cons "journal" "journal2")
    (cons "pubmed" "pubmed2")
    (cons "locations" (list "loc_a2" "loc_b2"))
    ))
  (list 'CAUSE (list 'point 'win) (list
    (cons "title" "title3")
    (cons "author" "author3")
    (cons "year" "year3")
    (cons "university" "univ3")
    (cons "topic" "topic3")
    (cons "journal" "journal3")
    (cons "pubmed" "pubmed3")
    (cons "locations" (list "loc_a3" "loc_b3"))
    ))
))

;(pp compound_obj_aliases)
;(pp knowledge)
(pp "knowledge done")
