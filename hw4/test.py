def rowStringToDict(headers, ln):
    """
    Convert a line of data in a CSV to a dictionary
    mapping the column header to each column cell.
    The keys and values of the dictionary should all be strings.

    Example:

    heads = ['Name','Age','Hair']
    ln    = 'Steve,25,Blonde'
    row   = rowStringToDict(heads, ln)

    row should be:
      {'Name' : 'Steve', 'Age' : '25', 'Hair' : 'Blonde'}

    Tip: use the split method on strings. See help(str.split)
    """

    return dict(zip(headers, ln.split(',')))

#rowStringToDict(['Name','Age','Hair'], 'Steve,25,Blonde')

assert(rowStringToDict(['Name','Age','Hair'], 'Steve,25,Blonde') == {'Name' : 'Steve', 'Age' : '25', 'Hair' : 'Blonde'})

def rowDictToString(headers, dict):
    """
    Converts a dictionary representation of a row back to string in CSV format.
    The headers argument determines the order of the values.

    Example:

    heads = ['Name','Age',PhoneNumber']
    row   = {'Name' : 'Steve', 'Age' : '25', 'PhoneNumber' : '3101345264'}
    ln    = rowDictToString(heads, row)

    ln should be: 'Steve,25,3101345264'

    Tip: use the join method on strings. See help(str.join)
    """

    result = ","
    line = []

    for i in headers:
        line.append(dict[i])

    return result.join(line)

assert(rowDictToString(['Name','Age','Hair'], {'Name' : 'Steve', 'Age' : '25', 'Hair' : 'Blonde'}) == 'Steve,25,Blonde')

class Identity:
    """
    Do nothing. Takes no arguments. Returns each row unchanged and does no aggregation.

    Example: running the Identity query on the file 'player_career_short.csv' should
    output the same file:

    Later, you can run this query from the command line via:
    $ python3 hw4.py player_career_short.csv -Identity

    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8
    """
    
    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        self.output_headers = in_headers
        self.aggregate_headers = []

    def process_row(self,row):
        # Do nothing; return the row unchanged.
        return row
    
    def get_aggregate(self):
        # No aggregation, return an empty row.
        return {}

class Count:
    """ 
    An example of a simple aggregator that counts the number of rows. Each row is unchanged.

    Example:
    
    $ python3 hw4.py player_career_short.csv -Count
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8

    Count
    9
    """
    
    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        self.output_headers = in_headers
        self.aggregate_headers = ['Count']

        # state for the aggregation
        self.count = 0

    def process_row(self,row):
        # update the state
        self.count += 1

        # return the row unchanged
        return row

    def get_aggregate(self):
        # return the aggregate row 
        return {'Count' : self.count}

#################### STEP 2 : Running queries ####################
# Before going and implementing your own queries, let's implement
# our query runner.
##################################################################

# We're going to be working with files.
#
# This is something I wanted to cover in class before assigning
# the homework, but we haven't yet.
#
# The following demonstrates everything you need to know about files
# for this homework. This prints the contents of the file "filename.txt"
# to standard output.
#
# f = open("filename.txt") # opens the file "filename.txt".
# for ln in f:             # iterate over the lines in the file.
#   ln = ln[:-1]           # remove the last character of the line, which is a newline.
#   print(ln)             
#

def runQuery(f, query):
    """
    Ok, so f is an object returned by open().
    Query is query object (it has process_row and get_aggregate methods, it has
    input_headers, output_headers, and aggregate_headers properties).

    We've already read the header line of f, since we needed that
    to build the query. Cool.

    Now to run the query, we must:
      print the output headers.

      for each line from f:
        convert the line to a dictionary of the form expected by the query.
        ask the query to process the row.
        if the query gives us an output row, print it in CSV form
    
      Once we're done processing the input rows, we need to print the aggregate table.

      Does the query even have an aggregate table? I.e. is aggregate_headers non-empty?
      If yes, print a blank line, then the aggregate headers, then the row of aggregate values.
    """

    # print the query's output headers.
    # Tip: use the join method on strings.
    #   try: ','.join(['A','B','C'])
    #   try: ' '.join(['A','B','C'])
    #   see: help(str.join)

    print(','.join(query.output_headers))

    # process each input line
    # Pseudocode:
    # for each line in the file f:
    #   convert the line from CSV format to a dictionary. use the query's input headers.
    #   tell the query to process the row.
    #   if query returns an output row, print it in CSV-format.
    #   if the query returns None, don't print anything.
    
    for ln in f:
        converted = rowStringToDict(query.input_headers, ln)
        current = query.process_row(converted)
        if current != None:
            print(rowDictToString(query.input_headers, converted))


    # did the query do any aggregation?
    if len(query.aggregate_headers) > 0:
        # yes. print the aggregate table.
        print(query.get_aggregate())

#################### Test it! ####################
# Here are some tests:

# Fire up the REPL, import everything from hw4, then
# try these tests:
#
# $ python3
# > from hw4 import *
# > runIdentity()
# > runCount()
#
# Check that you get the same output shown in the
# docstrings for Identity and Count.

def runIdentity():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    query = Identity(in_headers, [])

    # run it.
    runQuery(f, query)

    # should produce the output shown in the Identity docstring.

def runCount():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    query = Count(in_headers, [])

    # run it.
    runQuery(f, query)

    # should produce the output shown in the Count docstring.

#################### STEP 3 : Writing Queries ####################
# Time to implement a bunch of small query classes.
# You should write tests like runIdentity and runCount for each one!
##################################################################

    
class Rename:
    """
    Rename a column. That is, change the header of a column. Does no aggregation.
    
    Consumes two arguments from the front of args: the old header name and the new one.

    Check that the old header is in the input headers.
    Check that the new header is not in the input headers.
    
    Tip: Make sure in_headers != out_headers
    Tip: Use list(someList) to make a copy of someList. 
    Tip: Use the index method on lists. See: help([].index)

    Example: rename the 'gp' column to 'GamesPlayed'

    $ python3 hw4.py player_career_short.csv -Rename gp GamesPlayed
    id,firstname,lastname,leag,GamesPlayed,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8
    """
    
    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        consumed = [args.pop(0)]
        consumed.append(args.pop(0))
        in_headers_copy = in_headers
        in_headers_copy[in_headers_copy.index(consumed[0])] = consumed[1]
        self.output_headers = temp
        self.aggregate_headers = []

    def process_row(self,row):
        return row

    def get_aggregate(self):
        return {}


#################### Test it! ####################

def runRename():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['gp','GamesPlayed']
    query = Rename(in_headers, args)

    # should have consumed two args!
    assert(args == [])

    # run it.
    runQuery(f, query)

    # should produce the output shown in the Rename docstring.

class Swap:
    """
    Swap the positions of two columns. Does no aggregation.

    Consumes two arguments from the front of args: the two header names to be swapped.

    Tip: Make sure in_headers != out_headers
    Tip: Use list(someList) to make a copy of someList. 
    Tip: Use the index method on lists. See: help([].index)

    Example: Swap the firstname and lastname columns.

    $ python3 hw4.py player_career_short.csv -Swap firstname lastname
    id,lastname,firstname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,Abdelnaby,Alaa,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,Abdul-jabbar,Kareem,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Abdul-rauf,Mahmo,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,Abdul-wahad,Tariq,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,Abdur-rahim,Shareef,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,Abernethy,Tom,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,Able,Forest,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,Abramovic,John,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,Acker,Alex,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8

    Example: the order of the column arguments doesn't matter. This should produce the same
             output as above.
    $ python3 hw4.py player_career_short.csv -Swap lastname firstname
    """
    
    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        consumed = [args.pop(0)]
        consumed.append(args.pop(0))
        in_headers_copy = in_headers
        first = in_headers_copy.index(consumed[0])
        second = in_headers_copy.index(consumed[1])
        in_headers_copy[first], in_headers_copy[second] = in_headers_copy[second], in_headers_copy[first]
        self.output_headers = in_headers_copy
        self.aggregate_headers = []

        self.changed = [consumed[0], consumed[1]]

    def process_row(self,row):
        row[self.changed[0]], row[self.changed[1]] = row[self.changed[1]], row[self.changed[0]]
        return row

    def get_aggregate(self):
        return {}

#################### Test it! ####################

def runSwap():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['firstname','lastname', 'NotUsed!']
    query = Swap(in_headers, args)

    # should have consumed two args!
    assert(args == ['NotUsed!'])  

    # run it.
    runQuery(f, query)

    # should produce the output shown in the Swap docstring.

class Select:
    """
    Select a subset of columns to be included in the output. Does no aggregation.

    Consumes multiple arguments from args, until args is empty or args[0] is a
    flag (a string starting with '-').
    
    The arguments are the headers to be included in the output. You should check 
    that each is in in_headers.

    Example: 

    $ python3 hw4.py player_career_short.csv -Select firstname lastname gp pts
    firstname,lastname,gp,pts
    Alaa,Abdelnaby,256,1465
    Kareem,Abdul-jabbar,1560,38387
    Mahmo,Abdul-rauf,586,8553
    Tariq,Abdul-wahad,236,1830
    Shareef,Abdur-rahim,830,15028
    Tom,Abernethy,319,1779
    Forest,Able,1,0
    John,Abramovic,56,533
    Alex,Acker,30,81
    """

    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        consumed = []
        for i in args:
            if len(args) == 0 or list(str(args[0]))[0] == '-':
                break
            else:
                consumed.append(args.pop(0))
        consumed.reverse()

        self.aggregate_headers = []

    def process_row(self, row):
        raise Exception("Implement Select.process_row")

    def get_aggregate(self):
        return {}

#################### Test it! ####################

def runSelect1():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['firstname','lastname', 'gp', 'pts']
    query = Select(in_headers, args)

    # should have consumed all args!
    assert(args == [])  

    # run it.
    runQuery(f, query)


def runSelect2():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['firstname','lastname', 'gp', 'pts', '-Stop']
    query = Select(in_headers, args)

    # should have stopped at the flag
    assert(args == ['-Stop'])  

    # run it.
    runQuery(f, query)