;;; edbi-database-url.el --- Run edbi with database url

;; Copyright (C) 2014 by Malyshev Artem

;; Author: Malyshev Artem <proofit404@gmail.com>
;; URL: https://github.com/proofit404/edbi-database-url
;; Version: 1.0.0
;; Package-Requires: ((emacs "24") (edbi "0.1.3"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'edbi)
(require 'url-parse)

(defvar edbi-database-url-env "DATABASE_URL"
  "Environment variable used as database url.")

(defvar edbi-database-url-engines
  '(("postgres" . "Pg")
    ("postgresql" . "Pg")
    ("pgsql" . "Pg")
    ("sqlite" . "SQLite")
    ("mysql" . "mysql")
    ("mysql2" . "mysql"))
  "Database URL to DBI engines mapping.")

(defun edbi-database-url-read-url ()
  "Read database url from environment variable."
  (if (use-region-p)
      (buffer-substring-no-properties
       (region-beginning)
       (region-end))
    (or (getenv edbi-database-url-env)
        (read-string "Database URL: "))))

(defun edbi-database-url-parse-url (url)
  "Parse database URL."
  (url-generic-parse-url url))

(defun edbi-database-url-generate-uri (urlobj)
  "Generate DBI uri from URLOBJ struct."
  (format "dbi:%s:%s"
          ;; Engine.
          (let ((engine (url-type urlobj)))
            (or (cdr (assoc-string engine edbi-database-url-engines))
                (error "Unknown database url engine: %s" engine)))
          ;; Params.
          (concat
           (format "dbname=%s" (substring (url-filename urlobj) 1))
           (let ((host (url-host urlobj)))
             (when (not (equal host ""))
               (format ";host=%s" host)))
           (let ((port (url-portspec urlobj)))
             (when port
               (format ";port=%s" port))))))

(defun edbi-database-url-data-source (urlobj)
  "Create `edbi-data-source' from URLOBJ."
  (edbi:data-source
   (edbi-database-url-generate-uri urlobj)
   (url-user urlobj)
   (url-password urlobj)))

;;;###autoload
(defun edbi-database-url (url)
  "Open database url URL with `edbi'."
  (interactive (list (edbi-database-url-read-url)))
  (let* ((urlobj (edbi-database-url-parse-url url))
         (source (edbi-database-url-data-source urlobj))
         (conn (edbi:start)))
    (edbi:connect conn source)
    (edbi:dbview-open conn)))

(provide 'edbi-database-url)

;;; edbi-database-url.el ends here
