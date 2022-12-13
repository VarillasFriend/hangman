words = [
'undergarment',
'Czech',
'anywise',
'vibraphonist',
'congress',
'pause',
'nailer',
'winglike',
'hyaena',
'width',
'overprecise',
'salad',
'thermostatically',
'Dunbar',
'coupler',
'appreciator',
'indivisible',
'splenetic',
'Stein',
'casting',
'detachable',
'sobering',
'Madeiran',
'foundational',
'homewards',
'epidemiology',
'sawn',
'kaput',
'disheartenment',
'ecclesial',
'bellhop',
'confetti',
'keyboard',
'capacitative',
'Chelyabinsk',
'pestilential',
'Rossetti',
'Qom',
'Pavlovian',
'confluent',
'proleptic',
'ecclesiastic',
'unrenewed',
'nomad',
'mediocrity',
'chichi',
'paintbox',
'vocationally',
'volution',
'Jinan',
'boundary',
'cumbersomeness',
'epistemologist',
'Orel',
'Michigander',
'pretence',
'transnational',
'fidgety',
'comport',
'citrate',
'nonexperimental',
'dispassion',
'firedog',
'ballistic',
'graphitic',
'irresponsibility',
'rattling',
'centripetal',
'conjunctly',
'Government',
'extinct',
'tears',
'paramount',
'divisibility',
'irrecoverably',
'concavity',
'heterotrophic',
'boardinghouse',
'chidingly',
'grandioseness',
'motherliness',
'directorate',
'Namibian',
'subzero',
'suer',
'camellia',
'mileage',
'rink',
'inelastic',
'Quechua',
'Troja',
'amputator',
'verism',
'detrimentally',
'bottleful',
'foolproof',
'professionally',
'somebody',
'itchy',
'tastelessness']

require('json')

###
word = words.sample.downcase
wordog = word + '!'
leng = word.length

xword = ''

leng.times {|i| xword+='_'}

xword += "(#{leng})"

###
won = false
letters_used = ''
tries = 20
new={}

puts 'Do you want to load a game?'
wload = gets.chomp
if wload == 'yes' or wload == 'load'
    file = File.open('JSON/savedHangman.json', 'r')
    obj = file.read
    file.close
    obj2 = JSON.load obj
    word = obj2['word']
    xword = obj2['xword']
    letters_used = obj2['letters_used']
    tries = obj2['tries'] + 1
    wordog = obj2['og']
    puts 'Game loaded!'
end

tries.times do
    unless won
        puts "You have #{tries} tries"
        tries -= 1
        puts xword
        puts "Write only one letter"
        letter = gets.chomp
        if letter == 'save'
            file = File.open('JSON/savedHangman.json', 'w')
            info = {
                'word'=>word,
                'xword'=>xword,
                'letters_used'=>letters_used,
                'tries'=>tries,
                'og'=>wordog
            }
            file.puts info.to_json
            file.close
            puts 'Game saved!'
            won = true
        elsif letter != nil && letter.length == 1
            until !word.include? letter
                xword[word.index(letter)] = letter
                word[word.index(letter)] = '_'
                unless xword.include? '_'
                    puts "Congratulations!! You have won. The word was #{xword}"
                    won = true
                    file = File.open('JSON/savedHangman.json', 'w')
                    file.puts new
                    file.close
                end
            end 
            letters_used += letter + ' '
        end
        puts 'Letters you have used: ' + letters_used
    end
end

if !won
    puts "You have lost, the word was #{wordog}"
    file = File.open('JSON/savedHangman.json', 'w')
    file.puts new
    file.close
end
