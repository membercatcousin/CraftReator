let global_variables = [];

Blockly.utils.colour.setHsvSaturation(MCR_BLOCKLY_PREF['saturation']);
Blockly.utils.colour.setHsvValue(MCR_BLOCKLY_PREF['value']);

const blockly = document.getElementById('blockly');
const workspace = Blockly.inject(blockly, {
    media: 'res/',
    oneBasedIndex: false,
    sounds: false,
    comments: MCR_BLOCKLY_PREF['comments'],
    collapse: MCR_BLOCKLY_PREF['collapse'],
    disable: false,
    trashcan: MCR_BLOCKLY_PREF['trashcan'],
    renderer: 'zelos',
    grid: {
        spacing: 20,
        length: 2,
        colour: '#3d3d3d',
        snap: false
    },
    maxTrashcanContents: MCR_BLOCKLY_PREF['maxTrashContents'],
    zoom: {
        controls: false,
        wheel: true,
        startScale: 0.8,
        maxScale: 2.0,
        minScale: 0.3,
        scaleSpeed: 1.1
    },
    toolbox: '<xml id="toolbox"><category name="" colour=""></category></xml>'
});

const crossTabPlugin = new CrossTabCopyPaste();
crossTabPlugin.init({
    contextMenu: true,
    shortcut: true
}, null, editorType);

workspace.addChangeListener(function (event) {
    if (workspace.isDragging())
        return;

    if (event.isUiEvent)
        return;

    if (typeof javabridge !== "undefined")
        javabridge.triggerEvent();
});

window.addEventListener('resize', function () {
    Blockly.svgResize(workspace);
});
Blockly.svgResize(workspace);

Blockly.Block.prototype.setHelpUrl = function () {
    return '';
}

Blockly.Variables.allUsedVarModels = function () {
    return workspace.getVariableMap().getAllVariables();
};

Blockly.ContextMenuRegistry.registry.register({
    displayText: function () {
        return translate("blockly.context_menu.cleanup_unused_blocks");
    },
    preconditionFn: function (scope) {
        if (scope.workspace.getTopBlocks().length > 1) {
            return 'enabled';
        }
        return 'hidden';
    },
    callback: function (scope) {
        const group = Blockly.Events.getGroup();
        Blockly.Events.setGroup(true);
        for (const block of scope.workspace.getTopBlocks()) {
            if (block.type !== javabridge.startBlockForEditor(editorType))
                block.dispose();
        }
        Blockly.Events.setGroup(group);
    },
    scopeType: Blockly.ContextMenuRegistry.ScopeType.WORKSPACE,
    id: 'cleanupUnusedBlocks'
});

function getVariablesOfType(type) {
    let retval = [];

    workspace.getVariableMap().getAllVariables().forEach(function (v) {
        if (v.type === type)
            retval.push(["Local: " + v.name, "local:" + v.name]);
    });

    global_variables.forEach(function (v) {
        if (v.type === type)
            retval.push(["Global: " + v.name, "global:" + v.name]);
    });

    if (retval.length > 0)
        return retval;
    else
        return [["", ""]];
}

function getSerializedLocalVariables() {
    let retval = "";
    workspace.getVariableMap().getAllVariables().forEach(function (v, index, array) {
        retval += ((v.name + ";" + v.type) + (index < array.length - 1 ? ":" : ""));
    });
    return retval;
}

function arrayToBlocklyDropDownArray(arrorig) {
    let retval = [];
    arrorig.forEach(function (element) {
        retval.push(["" + element, "" + element]);
    });
    return retval;
}

function workspaceToXML() {
    const treeXml = Blockly.Xml.workspaceToDom(workspace, true);

    const variablesElements = treeXml.getElementsByTagName("variables");
    for (const varEl of variablesElements) {
        treeXml.removeChild(varEl);
    }

    const variablesElement = Blockly.Xml.variablesToDom(workspace.getVariableMap().getAllVariables());
    if (variablesElement.hasChildNodes()) {
        treeXml.prepend(variablesElement);
    }

    return Blockly.Xml.domToText(treeXml);
}
