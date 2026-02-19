#!/usr/bin/env python3
"""
Script to replace UIOBJECT wiki link patterns with apisig template.

Pattern:
 name = [[UIOBJECT FrameScriptObject|FrameScriptObject]]:GetName()

Replacement:
{{apisig|name = FrameScriptObject:GetName()}}
"""

import re

def replace_uiobject_pattern(text):
    """
    Replace UIOBJECT link patterns with apisig template format.
    
    Args:
        text: The text to process
        
    Returns:
        The text with replacements made
    """
    # Pattern: ` <varname> = [[UIOBJECT <object>|<object>]]:<method>()`
    # Replacement: `{{apisig|<varname> {{=}} <object>:<method>()}}`
    # pattern = r' (.+) = \[\[UIOBJECT ([^|]+)\|\2\]\]:(\w+)\((.+)\)'
    # replacement = r'{{apisig|\1 {{=}} \2:\3(\4)}}'

    # pattern = r' \[\[UIOBJECT ([^|]+)\|\1\]\]:(\w+)\((.+)\)'
    # replacement = r'{{apisig|\1:\2(\3)}}'

    # pattern = r' (.+),({{apisig\|)'
    # replacement = r'\2\1, '
    
    result = re.sub(pattern, replacement, text)
    return result

def main():
    # Example usage
    test_text = """ name = [[UIOBJECT FrameScriptObject|FrameScriptObject]]:GetName()
 value = [[UIOBJECT Frame|Frame]]:GetWidth()
 result = [[UIOBJECT Button|Button]]:IsEnabled()"""
    
    print("Original:")
    print(test_text)
    print("\nReplaced:")
    print(replace_uiobject_pattern(test_text))
    
    # To process a file, uncomment and modify:
    # with open('input.txt', 'r', encoding='utf-8') as f:
    #     content = f.read()
    # 
    # content = replace_uiobject_pattern(content)
    # 
    # with open('output.txt', 'w', encoding='utf-8') as f:
    #     f.write(content)

if __name__ == '__main__':
    main()
