import sys

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
        line.append(str(dict[i]))

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
            print(rowDictToString(query.output_headers, current))


    # did the query do any aggregation?
    if len(query.aggregate_headers) > 0:
        # yes. print the aggregate table.
        print(','.join(query.aggregate_headers))
        print(rowDictToString(query.aggregate_headers, query.get_aggregate()))

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
        self.output_headers = in_headers_copy
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
        for i in range(0, len(args)):
            if list(str(args[0]))[0] != '-':
                consumed.append(args.pop(0))

        self.output_headers = consumed

        self.aggregate_headers = []

        self.selected = consumed

    def process_row(self, row):
        row_result = {}
        for i in self.selected:
            row_result[i] = row[i]
        return row_result

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

class Filter:
    """
    Return only the rows that pass a check. Consumes a single argument from args, which
    is a python expression. For each row, check whether that row should be in the output
    by evaluating the expression. If the expression evaluates to True, then return the 
    row unchanged. If the expression evaluates to False, return None.

    Does no aggregation.

    Tip: use python's eval function to evaluate a string of python source code.
         See help(eval)

    Examples of eval:
        eval('1 + 2')   # evaluates to 3
        
    eval can take in an environment as its second argument, which binds values to variables
    in the expression. Use this feature to allow the expression to refer to the columns by name.

        eval('x + y', {'x' : 1, 'y' : 2})   # evaluates to 3

    Example: Players that played at least 500 games

    $ python3 hw4.py player_career_short.csv -Filter 'int(gp) > 500'
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    """

    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        consumed = [args.pop(0)]

        self.output_headers = in_headers

        self.aggregate_headers = []

        self.check = consumed[0]

    def process_row(self,row):
        try:
            if eval(eval(self.check), row) == False:
                return None
        except TypeError:
            if eval(self.check, row) == False:
                return None
        except NameError:
            if eval(self.check, row) == False:
                return None
        return row

    def get_aggregate(self):
        return {}

def runFilter():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['int(gp) > 500']
    query = Filter(in_headers, args)

    # should have consumed all args!
    assert(args == [])

    # run it.
    runQuery(f, query)

class Update:
    """ 
    Updates the values of a column. Consume two arguments from args: a column name
    and a python expression. Evaluate the expression using eval (as for Filter), 
    and assign the result to the designated column. Raise an exception if the
    column is not in in_headers. 

    Does no aggregation.

    Tip: use "x in l" to check if x is an element of l. See help('in').

    Example: Convert firstname to lower case.

    $ python3 hw4.py player_career_short.csv -Update firstname 'firstname.lower()'
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm
    ABDELAL01 ,alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0
    ABDULKA01 ,kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1
    ABDULMA01 ,mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474
    ABDULTA01 ,tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18
    ABDURSH01 ,shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154
    ABERNTO01 ,tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0
    ABLEFO01  ,forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0
    ABRAMJO01 ,john,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0
    ACKERAL01 ,alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8
    """
    
    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        consumed = [args.pop(0)]
        consumed.append(args.pop(0))
        self.output_headers = in_headers
        self.aggregate_headers = []

        if not(consumed[0] in self.input_headers):
            raise Exception('column given not in input headers')

        self.updated = consumed

    def process_row(self,row):
        try:
            temp = eval(eval(self.updated[1]), row)
            row[self.updated[0]] = temp
        except TypeError:
            temp = eval(self.updated[1], row)
            row[self.updated[0]] = temp
        except NameError:
            temp = eval(self.updated[1], row)
            row[self.updated[0]] = temp
        return row

    def get_aggregate(self):
        return {}

def runUpdate():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['firstname', 'firstname.lower()']
    query = Update(in_headers, args)

    # should have consumed all args!
    assert(args == [])

    # run it.
    runQuery(f, query)

class Add:
    """ 
    Add a new column to the database. Like Update, Add consumes two arguments 
    from args: a column name and a python expression. Raise an exception if 
    the column is in in_headers.

    Tip: use "x not in l" to check if x is *not* an element of l.
         "not (x in l)" also works.

    Example: compute the points per game for each player

    $ python3 hw4.py player_career_short.csv -Add ppg 'int(pts)/int(gp)'
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm,ppg
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0,5.72265625
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1,24.60705128205128
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474,14.595563139931741
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18,7.754237288135593
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154,18.106024096385543
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0,5.576802507836991
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0,0.0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0,9.517857142857142
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8,2.7
    """

    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        consumed = [args.pop(0)]
        consumed.append(args.pop(0))
        self.aggregate_headers = []
        input_headers_copy = in_headers

        if consumed[0] in self.input_headers:
            raise Exception('column given in input headers')
        else:
            input_headers_copy.append(consumed[0])
        self.output_headers = input_headers_copy

        self.added = consumed
               
    def process_row(self,row):
        try:
            temp = str(eval(eval(self.added[1]), row))
            row[self.added[0]] = temp
        except NameError:
            temp = str(eval(self.added[1], row))
            row[self.added[0]] = temp
        except TypeError:
            temp = str(eval(self.added[1], row))
            row[self.added[0]] = temp
        return row

    def get_aggregate(self):
        return {}

def runAdd():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['ppg', 'int(pts)/int(gp)']
    query = Add(in_headers, args)

    # should have consumed all args!
    assert(args == [])

    # run it.
    runQuery(f, query)

class MaxBy:
    """
    An aggregation that shows one column (the display column) of the player
    with a maximum value for another column (the value column). Assume the value column
    contains the string representation of an int. Use int() to convert each entry in the
    column to an int before the comparison.

    process_row returns each row unchanged.

    aggregate_headers should contain one column name, of the form:
      "Max <name of display column> By <name of value column>"

    Example: return the id of the player with the most minutes of play time.

    $ python3 hw4.py player_career_short.csv -MaxBy id minutes
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

    Max id By minutes
    ABDULKA01
    """
    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        self.output_headers = in_headers
        consumed = [args.pop(0)]
        consumed.append(args.pop(0))
        self.aggregate_headers = ['Max ' + consumed[0] + ' By ' + consumed[1]]

        self.max_params = consumed
        self.max = 0
        self.value = ''

    def process_row(self,row):
        check = float(row[self.max_params[1]])
        if check >= self.max:
            self.max = check
            self.value = row[self.max_params[0]]
        return row
    
    def get_aggregate(self):
        return {self.aggregate_headers[0] : self.value}

def runMaxBy():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['id', 'minutes']
    query = MaxBy(in_headers, args)

    # should have consumed all args!
    assert(args == [])

    # run it.
    runQuery(f, query)

class Sum:
    """
    An aggregation that sums all entries of a column. Takes one argument, the header 
    of the column to be summed. Produces an aggregate row containing one column, with
    header "<header> Sum" where <header> is the argument.

    Example: Compute the total number of turnovers.

    $ python3 hw4.py player_career_short.csv -Sum turnover
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

    turnover Sum
    6322
    """

    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        self.output_headers = in_headers
        consumed = [args.pop(0)]
        self.aggregate_headers = [consumed[0] + ' Sum']

        self.sum = 0
        self.to_sum = consumed

    def process_row(self,row):
        self.sum += int(row[self.to_sum[0]])
        return row

    def get_aggregate(self):
        return {self.aggregate_headers[0] : str(self.sum)}

def runSum():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['turnover']
    query = Sum(in_headers, args)

    # should have consumed all args!
    assert(args == [])

    # run it.
    runQuery(f, query)

class Mean:
    """
    An aggregation that computes the mean of all entries in a column.

    Example: Compute the average number of turnovers made by a player.

    $ python3 hw4.py player_career_short.csv -Mean turnover
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

    turnover Mean
    702.4444444444445
    """
    
    def __init__(self, in_headers, args):
        self.input_headers = in_headers
        self.output_headers = in_headers
        consumed = [args.pop(0)]
        self.aggregate_headers = [consumed[0] + ' Mean']

        self.mean = 0
        self.row_count = 0
        self.to_mean = consumed

    def process_row(self,row):
        self.mean += int(row[self.to_mean[0]])
        self.row_count += 1
        return row

    def get_aggregate(self):
        result = self.mean / self.row_count
        return {self.aggregate_headers[0] : str(result)}

def runMean():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['turnover']
    query = Mean(in_headers, args)

    # should have consumed all args!
    assert(args == [])

    # run it.
    runQuery(f, query)

class ComposeQueries:
    """ 
    Compose two queries into a larger query.

    The rows are processed serially: the output of the first query's process_row
    method is the input to the second queries process_row method. Note that the 
    first query could drop the row by returning None (Filter). In this case, you
    should not call the second query's process_row.

    You should "typecheck" the composition by checking that the first query's
    output_headers match the second query's input_headers.

    The input_headers of the composite are the input_headers of the first query.
    The output_headers of the composite are the output_headers of the second query.

    The aggregate row of the composite is the concatenation of the aggregates from
    the first and second query.

    You should ensure that the aggregate_headers of each input query are *distinct* --
    they should have no common elements. 

    Tip: use the update method on dictionaries to combine two dictionaries. 
         d = {'a' : 1, 'b' : 2}
         d.update({'c' : 3, 'd' : 4})
         print(d) # prints {'d': 4, 'b': 2, 'c': 3, 'a': 1}
    
    Note that ComposeQueries.__init__ does not take in_headers or args as input!
    q1 and q2 have already been constructed. We're simply combining them.

    Example: Show id of the player with the maximum steals per game.

    $ python3 hw4.py player_career_short.csv -Add stealsPerGame 'int(stl)/int(gp)' -MaxBy id stealsPerGame
    id,firstname,lastname,leag,gp,minutes,pts,oreb,dreb,reb,asts,stl,blk,turnover,pf,fga,fgm,fta,ftm,tpa,tpm,stealsPerGame
    ABDELAL01 ,Alaa,Abdelnaby,N,256,3200,1465,283,563,846,85,71,69,247,484,1236,620,321,225,3,0,0.27734375
    ABDULKA01 ,Kareem,Abdul-jabbar,N,1560,57446,38387,2975,9394,17440,5660,1160,3189,2527,4657,28307,15837,9304,6712,18,1,0.7435897435897436
    ABDULMA01 ,Mahmo,Abdul-rauf,N,586,15633,8553,219,868,1087,2079,487,46,963,1107,7943,3514,1161,1051,1339,474,0.8310580204778157
    ABDULTA01 ,Tariq,Abdul-wahad,N,236,4808,1830,286,490,776,266,184,82,309,485,1726,720,529,372,76,18,0.7796610169491526
    ABDURSH01 ,Shareef,Abdur-rahim,N,830,28883,15028,1869,4370,6239,2109,820,638,2136,2324,11515,5434,4943,4006,519,154,0.9879518072289156
    ABERNTO01 ,Tom,Abernethy,N,319,5434,1779,374,637,1011,384,185,60,129,525,1472,724,443,331,2,0,0.5799373040752351
    ABLEFO01  ,Forest,Able,N,1,1,0,0,0,1,1,0,0,0,1,2,0,0,0,0,0,0.0
    ABRAMJO01 ,John,Abramovic,N,56,0,533,0,0,0,37,0,0,0,171,855,203,185,127,0,0,0.0
    ACKERAL01 ,Alex,Acker,N,30,234,81,9,20,29,16,6,4,11,13,92,34,10,5,25,8,0.2

    Max id By stealsPerGame
    ABDELAL01 

    Once you can compose two queries, you should be able to compose any number of queries!

    """
    def __init__(self, q1, q2):
        self.input_headers = q1.input_headers
        self.output_headers = q2.output_headers
        self.aggregate_headers = q1.aggregate_headers + q2.aggregate_headers

        self.queries = [q1, q2]

    def process_row(self,row):
        if self.queries[0].process_row(row) != None:
            return self.queries[1].process_row(self.queries[0].process_row(row))
        else:
            return None

    def get_aggregate(self):
        try:
            if len(self.queries[0].get_aggregate()) > 0 and len(self.queries[1].get_aggregate()) > 0:
                return self.queries[0].get_aggregate().update(self.queries[1].get_aggregate())
            elif len(self.queries[0].get_aggregate()) <= 0 and len(self.queries[1].get_aggregate()) > 0:
                return self.queries[1].get_aggregate()
            elif len(self.queries[0].get_aggregate()) > 0 and len(self.queries[1].get_aggregate()) <= 0:
                return self.queries[0].get_aggregate()
            else:
                return {}
        except TypeError:
            return {}
        

#################### Test it! ####################

def runComposite():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['-Add', 'stealsPerGame', 'int(stl)/int(gp)', '-MaxBy', 'id', 'stealsPerGame']

    # ok, first query is Add. pop off the flag.
    args.pop(0)

    # build the first query
    q1 = Add(in_headers, args)

    # the input of second query is the output of first query
    next_in_headers = q1.output_headers

    assert(args == ['-MaxBy', 'id', 'stealsPerGame'])

    # ok, second query is MaxBy. pop off the flag.
    args.pop(0)
    
    q2 = MaxBy(next_in_headers, args)

    assert(args == [])

    # build the composite query.
    query = ComposeQueries(q1,q2)
    
    # run it.
    runQuery(f, query)

    # should produce the output shown in the ComposeQueries docstring.

def runComposite2():
    f = open('player_career_short.csv')

    # get the input headers
    in_headers = f.readline().strip().split(',')

    # build the query
    args = ['-Filter', 'float(minutes) > 0', '-Add', 'ppm', 'float(pts)/float(minutes)']

    # ok, first query is Float. pop off the flag.
    args.pop(0)

    # build the first query
    q1 = Filter(in_headers, args)

    # the input of second query is the output of first query
    next_in_headers = q1.output_headers

    assert(args == ['-Add', 'ppm', 'float(pts)/float(minutes)'])

    # ok, second query is Add. pop off the flag.
    args.pop(0)
    
    q2 = Add(next_in_headers, args)

    assert(args == [])

    # build the composite query.
    query = ComposeQueries(q1,q2)
    
    # run it.
    runQuery(f, query)

    # should produce the output shown in the ComposeQueries docstring.

################# STEP 5 : Building composite queries ################
# Implement buildQuery
######################################################################

# We store all the query classes in a dictionary, so constructing
# any query is easy: use the flag to lookup the query class, then
# apply the class like a function.
#
# Example: construct an instance of the Identity class.
#
# queries['Identity'](in_headers,args)   
    
queries = {
    'Identity' : Identity,
    'Rename'   : Rename,
    'Select'   : Select,
    'Swap'     : Swap,
    'Filter'   : Filter,
    'Update'   : Update,
    'Add'      : Add,
    'Count'    : Count,
    'MaxBy'    : MaxBy,
    'Sum'      : Sum,
    'Mean'     : Mean
    }

def buildQuery(in_headers, args):
    """
    Build the composite query.

    The first argument of args should be a flag (a string starting with '-').

    Use that to lookup the query class from queries. 

    Once you get the query class, remove the flag from args.

    Call the class with in_headers and args to build the query.

    For example, this builds an Identity:
      queries['Identity'](in_headers, args)

    Keep building up the query until args is empty.
    """

    # initially, we just have an identity query.
    query = Identity(in_headers,args)

    while(len(args) > 0):
        check = args.pop(0)
        broken = list(check)
        if broken[0] == '-':
            broken.remove('-')
            to_compose = queries[''.join(broken)]
            query = ComposeQueries(query, to_compose(query.output_headers, args))

    return query

#################### STEP 6: Testing ####################
# Now the command line examples should work!
#
# Test them! Come up with some more tests of your own!!!
#
# CELEBRATE!!!!!!
#
# Some larger queries to try:
#
# Example: Maximum number of points per minute. Filter out players that played 0 minutes to prevent divide by zero.
#
# $ python3 hw4.py player_career.csv -Filter 'float(minutes) > 0' -Add ppm 'float(pts)/float(minutes)' -MaxBy ppm ppm
#
# Example: Show the first and last names of the players with the maximum points per game, and the maximum number of points per minute.
#
# $ python3 hw4.py player_career.csv -Filter 'float(minutes) > 0' -Add first_last 'firstname + " " + lastname' -Add ppg 'float(pts)/float(gp)' -Add ppm 'float(pts)/float(minutes)' -MaxBy first_last ppg -MaxBy first_last ppm
#
# Example: Now include maximum values of pointsPerGame and pointsPerMinute, and end with -Filter 'False' to show only the aggregate row.
#
# $ python3 hw4.py player_career.csv -Filter 'float(minutes) > 0' -Add first_last 'firstname + " " + lastname' -Add ppg 'float(pts)/float(gp)' -Add ppm 'float(pts)/float(minutes)' -MaxBy first_last ppg -MaxBy ppg ppg -MaxBy first_last ppm -MaxBy ppm ppm -Filter 'False'
#
# Example: Count the number of players with at least 1 point per minute on average.
#
# $ python3 hw4.py player_career.csv -Filter 'int(minutes) > 0' -Add ppm 'float(pts)/float(minutes)' -Filter 'float(ppm) > 1' -Count

##############################################################

def main():   
    # arguments start from position 1, since position 0 is always 'hw4.py'
    args = sys.argv[1:]

    # first argument is the input file. see help(list.pop)
    fname = args.pop(0)
    
    # Open that file! see help(open)
    f = open(fname)
    
    # read the headers (first line) from the input CSV file.
    # f.readline() returns a string ending with a newline '\n'
    # The method str.strip() removes it. See help(str.strip)
    # The method str.split() splits a string into a list of strings
    #   try: 'A,B,C'.split(',')
    #   see: help(str.split)
    in_headers = f.readline().strip().split(',')
    
    # build the query
    query = buildQuery(in_headers, args)

    # after building the query, all arguments should be consumed.
    assert(len(args) == 0)
    
    # run the query.
    runQuery(f,query)

if __name__ == "__main__":
    main()