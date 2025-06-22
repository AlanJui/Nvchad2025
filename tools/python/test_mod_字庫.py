import sys; sys.path.insert(0, ".")

import unittest

import xlwings as xw

from mod_字庫 import JiKhooDict


class TestJiKhooDict(unittest.TestCase):

    def test_add_entry(self):
        ji_khoo = JiKhooDict()
        ji_khoo.add_entry("雨", "hoo7", "N/A", (5, 14))
        ji_khoo.add_entry("雨", "hoo7", "N/A", (5, 17))
        ji_khoo.add_entry("雨", "u2", "N/A", (5, 18))

        entries = ji_khoo.get_entry("雨")
        self.assertEqual(len(entries), 2)
        self.assertEqual(entries[0]["tai_gi_im_piau"], "hoo7")
        self.assertIn((5, 14), entries[0]["coordinates"])
        self.assertIn((5, 18), entries[1]["coordinates"])

    def test_multiple_readings(self):
        ji_khoo = JiKhooDict()
        ji_khoo.add_entry("雨", "hoo7", "N/A", (5, 14))
        ji_khoo.add_entry("雨", "hoo7", "N/A", (5, 17))
        ji_khoo.add_entry("雨", "u2", "N/A", (57, 18))

        entries = ji_khoo.get_entry("雨")
        self.assertEqual(len(entries), 2)
        self.assertEqual(entries[0]["tai_gi_im_piau"], "hoo7")
        self.assertEqual(entries[1]["tai_gi_im_piau"], "u2")

    def test_write_to_excel_sheet(self):
        wb = xw.Book()
        ji_khoo = JiKhooDict()
        ji_khoo.add_entry("雨", "hoo7", "N/A", (5, 14))
        ji_khoo.add_entry("雨", "hoo7", "N/A", (5, 17))
        ji_khoo.add_entry("雨", "u2", "N/A", (57, 18))

        ji_khoo.write_to_excel_sheet(wb, "漢字庫")
        sheet = wb.sheets["漢字庫"]
        data = sheet.range("A2").expand("table").value

        self.assertEqual(len(data), 2)
        self.assertEqual(data[0][0], "雨")
        self.assertEqual(data[0][1], "hoo7")
        self.assertEqual(data[1][1], "u2")
        # self.assertEqual(data[2][1], "u2")

        wb.close()

    def test_create_ji_khoo_dict_from_sheet(self):
        wb = xw.Book()
        sheet = wb.sheets.add("漢字庫")
        sheet.range("A1").value = ["漢字", "台語音標", "校正音標", "座標"]
        sheet.range("A2").value = [
            ["雨", "hoo7", "N/A", "(5, 14)"],
            ["雨", "hoo7", "N/A", "(5, 17)"],
            ["雨", "u2", "N/A", "(57, 18)"]
        ]

        ji_khoo = JiKhooDict.create_ji_khoo_dict_from_sheet(wb, "漢字庫")
        entries = ji_khoo.get_entry("雨")

        self.assertEqual(len(entries), 2)
        self.assertEqual(entries[0]["tai_gi_im_piau"], "hoo7")
        self.assertEqual(entries[1]["tai_gi_im_piau"], "u2")

        wb.close()


# if __name__ == "__main__":
#     unittest.main()
if __name__ == "__main__":
    suite = unittest.TestSuite()
    suite.addTest(TestJiKhooDict('test_write_to_excel_sheet'))
    suite.addTest(TestJiKhooDict('test_create_ji_khoo_dict_from_sheet'))
    suite.addTest(TestJiKhooDict('test_add_entry'))
    suite.addTest(TestJiKhooDict('test_multiple_readings'))

    runner = unittest.TextTestRunner()
    runner.run(suite)
