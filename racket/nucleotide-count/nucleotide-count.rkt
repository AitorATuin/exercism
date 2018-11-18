#lang racket

(require racket/hash)

(provide nucleotide-counts)

(define (nucleotide-counts dna)
  (foldl (λ (c d) (dict-update d c add1))
         '((#\A . 0) (#\C . 0) (#\G . 0) (#\T . 0))
         (string->list dna)))
