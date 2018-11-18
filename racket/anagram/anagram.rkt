#lang racket

(provide anagrams-for)

(define (anagrams-for anagram candidates)
  (define (sorted-list word)
    (sort (string->list (string-downcase word)) char<?))
  (let ([anagram-list (sorted-list anagram)])
    (filter (λ (candidate) (equal? anagram-list (sorted-list candidate)))
            (remove anagram candidates))))
