# Author: @BlassGO
# Description: Convert between different units using a configuration file
# Usage: convert [options] <number><from_unit> <to_unit>
# Options:
#   -d, -decimals <n> : Number of decimal places in the output (default: 16)
#   -s, -show         : Show the conversion sequence
# Environment Variables:
#   convert_from     : Default 'from' unit if not specified
#   convert_to       : Default 'to' unit if not specified
#   convert_config   : Path to the configuration file

convert() {
    local decimals=16 show
    while [ $# -gt 0 ]; do
        case $1 in
            -d|-decimals) decimals=$2; shift 2 ;;
            -s|-show) show=true; shift ;;
            *) break ;;
        esac
    done
    awk -v from="$1" -v to="$2" \
        -v from_env="$convert_from" -v to_env="$convert_to" \
        -v decimals="$decimals" -v show="$show" '
    BEGIN {
        num = from + 0
        if (num) {
            from = substr(from, length(num) + 1)
        } else {
            num = 1
        }

        if (from == "") from = from_env
        if (to == "") to = to_env

        if (from == "" || to == "") {
            print "convert v1.0.0, Author: @BlassGO\n" > "/dev/stderr"
            print "Usage: convert [options] <number><from_unit> <to_unit>" > "/dev/stderr"
            print "Options: -d <n> for decimals, -s for showing conversion sequence" > "/dev/stderr"
            exit 1
        }
        foundGroup = 0
        result = num
        quote = "\""
        fromq = quote from quote
        toq = quote to quote
    }
    (substr($0, 1, 1) == "#") { next }
    index($0, "[") {
        if (foundGroup) {
            exit
        } else if (index($0, fromq) && index($0, toq)) {
            foundGroup = 1
        } 
    }
    foundGroup && index($0, "=") {
        line = $0
        gsub(/[ \t]*=[ \t]*/, "=", line)
        split(line, parts, "=")
        
        if (length(parts) == 2) {
            left = parts[1]
            right = parts[2]
            leftValue = left + 0
            leftUnit = substr(left, length(leftValue) + 1)
            rightValue = right + 0
            rightUnit = substr(right, length(rightValue) + 1)
            
            if (leftValue && leftUnit && rightValue && rightUnit) {
                conversion[leftUnit "|" rightUnit] = rightValue / leftValue
                conversion[rightUnit "|" leftUnit] = leftValue / rightValue

                if (!(leftUnit in graph)) {
                    graph[leftUnit] = ""
                }
                if (!(rightUnit in graph)) {
                    graph[rightUnit] = ""
                }
                graph[leftUnit] = graph[leftUnit] " " rightUnit
                graph[rightUnit] = graph[rightUnit] " " leftUnit
            }
        }
    }
    END {
        if (!(from in graph) || !(to in graph)) {
            print "convert: Units not connected in the graph: " from " -> " to > "/dev/stderr"
            exit 1
        }

        queue_from = 1
        queue_to = 1
        queue[queue_to] = from
        visited[from] = 1
        path[from] = ""

        while (queue_from <= queue_to) {
            current = queue[queue_from]
            queue_from++

            if (current == to) {
                conversion_factor = 1
                node = to
                conversion_path = num from

                while (node != from) {
                    prev = path[node]
                    conversion_factor *= conversion[prev "|" node]
                    node = prev
                    if (show && node!=from) conversion_path = conversion_path " | " (num * conversion_factor) node 
                }
                
                result = num * conversion_factor

                if (show) {
                    print "Conversion sequence:"
                    if (result == int(result)) {
                       print conversion_path " -> " int(result) to
                    } else {
                       printf "%s%." decimals "f%s\n", conversion_path " -> ", result, to
                    }
                } else if (result == int(result)) {
                    print int(result)
                } else {
                    printf "%." decimals "f\n", result
                }
                exit
            }

            split(graph[current], neighbors, " ")
            for (i in neighbors) {
                neighbor = neighbors[i]

                if (!(neighbor in visited)) {
                    visited[neighbor] = 1
                    path[neighbor] = current
                    queue_to++
                    queue[queue_to] = neighbor
                }
            }
        }

        print "convert: No path found between " from " and " to > "/dev/stderr"
        exit 1
    }
   ' "${convert_config:-$HOME/.config/convert/units.config}"
}