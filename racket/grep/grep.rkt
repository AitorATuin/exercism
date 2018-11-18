#lang racket/base

(require racket/match)
(require racket/format)
(require racket/set)
(require racket/list)
(require racket/port)
(require racket/cmdline)

(provide grep)

(define (grep-mods flags)
  (foldl (λ (flag mods) (match flag
                          ["-i" (~a "i" mods)]
                          [else mods])) "" flags))

(define (grep-pattern flags pattern)
  (cond
    [(set-member? flags "-x") (~a "^" pattern "$")]
    [else pattern]))

(define ((grep-f flags pattern) line)
  (let* ([mods (grep-mods flags)]
         [pattern (grep-pattern flags pattern)]
         [re (regexp (~a "(?" mods ":" pattern ")"))]
         [matched (regexp-match? re line)])
    (cond
      [(set-member? flags "-v") (not matched)]
      [else matched])))

(define (output-map flags files)
  (let ([one-file? (= 1 (length files))])
    (cond
      [(set-member? flags "-l")
       (λ (f n l) f)]
      [(and (set-member? flags "-n") one-file?)
       (λ (f n l) (~a n ":" l))]
      [(set-member? flags "-n")
       (λ (f n l) (~a f ":" n ":" l))]
      [one-file?
       (λ (f n l) l)]
      [else
       (λ (f n l) (~a f ":" l))])))

(define (zip xs [n 0])
  (map cons (range 1 (add1 (length xs))) xs))

(define (grep-list flags pattern files)
  (let ([match? (grep-f flags pattern)])
    (for*/list ([p (map (λ (f) (cons f (open-input-file f))) files)]
                [l (zip (port->list read-line (cdr p)))]
                #:when (match? (cdr l)))
      (list (car p) (car l) (cdr l)))))

(define (grep flags pattern files)
  (let* ([output-f (output-map flags files)]
         [result (grep-list flags pattern files)])
    (remove-duplicates (map (λ (x) (apply output-f x)) result))))

(module+ main
  (define flags (make-parameter null))
  (define (add-flag flag) (flags (cons flag (flags)))) 
  (command-line
   #:program "grep"
   #:once-each
   [("-i") "Match line using a case-insensitive comparison."
           (add-flag "-i")]
   [("-l") "Print only the names of files that contain at least one matching line."
           (add-flag "-l")]
   [("-n") "Print the line numbers of each matching line."
           (add-flag "-n")]
   [("-v") "Invert the program -- collect all lines that fail to match the pattern."
           (add-flag "-v")]
   [("-x") "Only match entire lines, instead of lines that contain a match."
           (add-flag "-x")]
   #:args (pattern first-file . rest-files)
   (for [(l (grep (flags) pattern (cons first-file rest-files)))]
     (printf "~a\n" l))))
