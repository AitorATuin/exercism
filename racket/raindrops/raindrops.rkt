#lang racket

(provide convert)

(define factors '((3 "Pling") (5 "Plang") (7 "Plong")))

(define (convert number)
  (define (factor? factor) (zero? (modulo number factor)))
  (let* ([result-list (map (λ (p) (if (factor? (first p)) (second p) "")) factors)]
         [result-str (foldl string-append "" (reverse result-list))])
    (if (zero? (string-length result-str))
        (number->string number)
        result-str)))

