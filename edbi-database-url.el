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

(require 'json)
(require 'edbi)

(defvar edbi-database-url-env "DATABASE_URL"
  "Environment variable used as database url.")

(defun edbi-database-url-read-url ()
  "Read database url from environment variable."
  (if current-prefix-arg
      (read-string "Database URL: ")
    (or (getenv edbi-database-url-env)
        (error "Unspecified %s environment variable"
               edbi-database-url-env))))

(provide 'edbi-database-url)

;;; edbi-database-url.el ends here
