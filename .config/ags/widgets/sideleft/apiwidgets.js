const { Gdk, GLib, Gtk, Pango } = imports.gi;
import { App, Utils, Widget } from '../../imports.js';
const { Box, Button, Entry, EventBox, Icon, Label, Revealer, Scrollable, Stack } = Widget;
const { execAsync, exec } = Utils;
import ChatGPT from '../../services/chatgpt.js';
import { MaterialIcon } from "../../lib/materialicon.js";
import { setupCursorHover, setupCursorHoverInfo } from "../../lib/cursorhover.js";
import { SystemMessage, ChatMessage } from "./chatmessage.js";
import { ConfigToggle } from '../../lib/configwidgets.js';
import { markdownTest } from './md2pango.js';
import {
    chatGPTInfo, chatGPTSettings,
    openaiApiKeyInstructions, chatGPTWelcome,
    chatContent, chatGPTView,
    chatGPTCommands
} from './apis/chatgpt.js';

const ApiSwitcherTabButton = (stack, stackItem, navIndicator, navIndex, icon, label) => Widget.Button({
    // hexpand: true,
    className: 'sidebar-selector-tab',
    onClicked: (self) => {
        stack.shown = stackItem;
        // Add active class to self and remove for others
        const allTabs = self.get_parent().get_children();
        for (let i = 0; i < allTabs.length; i++) {
            if (allTabs[i] != self) allTabs[i].toggleClassName('sidebar-selector-tab-active', false);
            else self.toggleClassName('sidebar-selector-tab-active', true);
        }
        // Fancy highlighter line width
        const buttonWidth = self.get_allocated_width();
        const highlightWidth = self.get_children()[0].get_allocated_width();
        navIndicator.css = `
            font-size: ${navIndex}px; 
            padding: 0px ${(buttonWidth - highlightWidth) / 2}px;
        `;
    },
    child: Box({
        hpack: 'center',
        className: 'spacing-h-5',
        children: [
            MaterialIcon(icon, 'larger'),
            Label({
                className: 'txt txt-smallie',
                label: label,
            })
        ]
    }),
    setup: (button) => Utils.timeout(1, () => {
        setupCursorHover(button);
        button.toggleClassName('sidebar-selector-tab-active', defaultTab === stackItem);
    }),
});

const apiSwitcher = Box({
    vertical: true,
    children: [
        Box({
            homogeneous: true,
            children: [
                // ApiSwitcherTabButton(contentStack, 'apis', navIndicator, 0, 'api', 'APIs'),
                // ApiSwitcherTabButton(contentStack, 'tools', navIndicator, 1, 'home_repair_service', 'Tools'),
            ]
        }),
    ]
})

const sendChatMessage = () => {
    // Check if text or API key is empty
    if (chatEntry.text.length == 0) return;
    if (ChatGPT.key.length == 0) {
        ChatGPT.key = chatEntry.text;
        chatContent.add(SystemMessage(`Key saved to\n\`${ChatGPT.keyPath}\``, 'API Key'));
        chatEntry.text = '';
        return;
    }
    // Commands
    if (chatEntry.text.startsWith('/')) {
        if (chatEntry.text.startsWith('/clear')) ChatGPT.clear();
        else if (chatEntry.text.startsWith('/model')) chatContent.add(SystemMessage(`Currently using \`${ChatGPT.modelName}\``, '/model'))
        else if (chatEntry.text.startsWith('/key')) {
            const parts = chatEntry.text.split(' ');
            if (parts.length == 1) chatContent.add(SystemMessage(`See \`${ChatGPT.keyPath}\``, '/key'));
            else {
                ChatGPT.key = parts[1];
                chatContent.add(SystemMessage(`Updated API Key at\n\`${ChatGPT.keyPath}\``, '/key'));
            }
        }
        else if (chatEntry.text.startsWith('/test'))
            chatContent.add(SystemMessage(markdownTest, `Markdown test`));
        else
            chatContent.add(SystemMessage(`Invalid command.`, 'Error'))
    }
    else {
        ChatGPT.send(chatEntry.text);
    }

    chatEntry.text = '';
}

const chatSendButton = Button({
    className: 'txt-norm icon-material sidebar-chat-send',
    vpack: 'center',
    label: 'arrow_upward',
    setup: setupCursorHover,
    onClicked: (self) => sendChatMessage(),
});

export const chatEntry = Entry({
    className: 'sidebar-chat-entry',
    hexpand: true,
    connections: [
        [ChatGPT, (self, hasKey) => {
            self.placeholderText = (ChatGPT.key.length > 0 ? 'Ask a question...' : 'Enter OpenAI API Key...');
        }, 'hasKey']
    ],
    onChange: (entry) => {
        chatSendButton.toggleClassName('sidebar-chat-send-available', entry.text.length > 0);
    },
    onAccept: () => sendChatMessage(),
});

const textboxArea = Box({ // Entry area
    className: 'sidebar-chat-textarea spacing-h-10',
    children: [
        chatEntry,
        chatSendButton,
    ]
});

const apiContentStack = Stack({
    vexpand: true,
    transition: 'slide_left_right',
    items: [
        ['chatgpt', chatGPTView],
    ],
})

const apiCommandStack = Stack({
    transition: 'slide_up_down',
    items: [
        ['chatgpt', chatGPTCommands],
    ],
})

export default Widget.Box({
    vertical: true,
    className: 'spacing-v-10',
    homogeneous: false,
    children: [
        apiSwitcher,
        apiContentStack,
        apiCommandStack,
        textboxArea,
    ]
});
