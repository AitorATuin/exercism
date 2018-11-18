#lang racket

(provide to-rna)

(define (to-rna dna)
  (list->string
   (map (λ (n)
          (match n [#\G #\C] [#\C #\G] [#\T #\A] [#\A #\U]))
        (string->list dna))))
