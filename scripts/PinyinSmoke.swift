import Foundation

@main
struct PinyinSmoke {
    static func main() throws {
        guard CommandLine.arguments.count == 2 else {
            fatalError("Pass the path to PinyinLexicon.tsv")
        }
        let dictionaryURL = URL(fileURLWithPath: CommandLine.arguments[1])
        let dictionary = try String(contentsOf: dictionaryURL, encoding: .utf8)
        var composition = PinyinComposition(lexicon: PinyinLexicon(tsv: dictionary))

        precondition(!composition.isActive)
        precondition(composition.commit() == nil)
        precondition(!composition.deleteBackward())
        precondition(!composition.append("'"))

        type("nihao", into: &composition)
        precondition(composition.candidates.first == "你好")
        precondition(composition.commit() == "你好")
        precondition(!composition.isActive && composition.candidates.isEmpty)

        type("woaininihao", into: &composition)
        precondition(composition.commit() == "我爱你你好", "Expected the two dictionary phrases to combine")

        type("xian", into: &composition)
        precondition(composition.commit() == "先")
        type("xi'an", into: &composition)
        precondition(composition.candidates.first == "西安")
        precondition(!composition.candidates.contains("先"), "Apostrophe must rule out a single syllable")
        precondition(composition.commit() == "西安")

        type("hei", into: &composition)
        precondition(Array(composition.candidates.prefix(2)) == ["黑", "嘿"])
        precondition(composition.commit("候选项不存在") == nil && composition.spelling == "hei")
        precondition(composition.commit("嘿") == "嘿")

        type("qqqqq", into: &composition)
        precondition(composition.candidates.isEmpty)
        precondition(composition.commit() == "qqqqq", "A spelling with no candidate remains literal")

        type("nihaoma", into: &composition)
        precondition(composition.candidates.first == "你好吗")
        precondition(composition.deleteBackward())
        precondition(composition.deleteBackward())
        precondition(composition.spelling == "nihao" && composition.candidates.first == "你好")
        composition.reset()
        precondition(composition.spelling.isEmpty && composition.candidates.isEmpty && !composition.isActive)

        type("nüer", into: &composition)
        precondition(composition.spelling == "nver")
        precondition(composition.commit() == "女儿")

        print("Pinyin checks passed")
    }

    private static func type(_ spelling: String, into composition: inout PinyinComposition) {
        for character in spelling {
            precondition(composition.append(String(character)), "Unexpected key in '\(spelling)'")
        }
    }
}
